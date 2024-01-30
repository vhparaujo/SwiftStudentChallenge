//
//  File.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 11/12/23.
//

import ARKit
import RealityKit
import UIKit
import Combine

class Coordinator: NSObject, ARSessionDelegate {
    
    weak var arView: ARView?
    
    var cancellable: AnyCancellable?
    
    var ball: ModelEntity!
    var racquet: ModelEntity!
    var racquet2: ModelEntity!
    var court: ModelEntity!
    
    var opponentScore: Int = 0
    var playerScore: Int = 0
    
    var initialPanPosition: CGPoint = .zero
    
    func buildFirstScene() {
        
        guard let view = arView else { return }
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
        
        let modelEntity = ModelEntity()
        
        let score = ModelEntity(mesh: MeshResource.generateText("Score: \(self.playerScore) X \(self.opponentScore)", extrusionDepth: 0.03, font: .systemFont(ofSize: 0.09), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .blue, isMetallic: false)])
        
        score.position = [-0.7, 1, 0]
        
        cancellable = ModelEntity.loadModelAsync(named: "tennisCourt")
            .append(ModelEntity.loadModelAsync(named: "ball"))
            .append(ModelEntity.loadModelAsync(named: "racquet"))
            .collect()
            .sink(receiveCompletion: { loadCompletion in
                if case let .failure(error) = loadCompletion {
                    print("Unable to load model \(error)")
                }
                
                self.cancellable?.cancel()
                
            }, receiveValue: { entities in
                
                entities.forEach { entity in
                    entity.generateCollisionShapes(recursive: true)
                    entity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
                }
                
                entities[0].position.z = -1
                self.court = entities[0]
                
                // ball
                entities[1].position = simd_make_float3(self.court.position.x, self.court.position.y + 1.3, self.court.position.z - 2.3)
                entities[1].scale = [0.09, 0.09, 0.09]
                self.ball = entities[1]
                
                
                // racquet yellow
                entities[2].position = simd_make_float3(self.court.position.x, self.court.position.y + 0.5, self.court.position.z + 1)
                
                entities[2].scale = [0.2, 0.2, 0.2]
                self.racquet = entities[2]
                
                
                // entities
                entities.forEach { entity in
                    modelEntity.addChild(entity)
                }
                
            })
        
        view.scene.addAnchor(anchor)
        
        modelEntity.addChild(score)
        anchor.addChild(modelEntity)
        
        view.installGestures(.scale.union(.translation), for: modelEntity)
    }
    
    
    func removeTheScene() {
        guard let arView = self.arView else { return }
        
        arView.scene.anchors.removeAll()
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            
        // Calculate the direction from the ball to the racquet
        let direction = normalize(racquet.position - ball.position)
        
        // Apply an impulse to the ball in the calculated direction
        let impulse = direction * 5.21836
        
        ball.physicsBody?.mode = .dynamic
        
        //        ball.addForce(impulse, relativeTo: nil)
        
        
        ball.applyLinearImpulse(impulse, relativeTo: racquet)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.removeTheScene()
            
        }
        
    }
    
    //    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    //
    //        guard let view = self.arView else {return}
    //
    //        switch gesture.state {
    //        case .began:
    //
    //            // Save the initial position of the pan gesture
    //            initialPanPosition = gesture.location(in: view)
    //
    //            guard let tappedEntity = view.entity(at: initialPanPosition) as? ModelEntity else {
    //                return
    //            }
    //
    //            guard tappedEntity == racquet else {
    //                return
    //            }
    //
    //            view.gestureRecognizers?.forEach { view.removeGestureRecognizer($0) }
    //
    //        case .changed:
    //            // Calculate the distance based on the change in x-position of the pan gesture
    //            let currentPanPosition = gesture.location(in: view)
    //            let distance = Float(currentPanPosition.x - initialPanPosition.x) * 0.001 // Adjust the multiplier as needed
    //
    //            //            guard let tappedEntity = view.entity(at: currentPanPosition) as? ModelEntity else {
    //            //                return
    //            //            }
    //            //
    //            //            guard tappedEntity == racquet else {
    //            //                return
    //            //            }
    //
    //            view.gestureRecognizers?.forEach { view.removeGestureRecognizer($0) }
    //
    //            // Move the entity along the x-axis
    //            racquet.moveAlongXAxis(distance: distance)
    //
    //            // Update the initial position for the next iteration
    //            initialPanPosition = currentPanPosition
    //
    //        default:
    //            break
    //        }
    //    }
    
}


extension ModelEntity {
    func moveAlongXAxis(distance: Float) {
        transform.translation.x += distance
    }
}
