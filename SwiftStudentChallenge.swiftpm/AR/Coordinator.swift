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
        
        guard let arView = self.arView else {return}
        
        let tapLocation = recognizer.location(in: arView)
        
        guard let tappedEntity = arView.entity(at: tapLocation) as? ModelEntity else {
            return
        }
        
        guard tappedEntity == ball else {
            return
        }
        
        // Calculate the direction from the ball to the racquet
        let direction = normalize(racquet.position - ball.position)
        
        // Apply an impulse to the ball in the calculated direction
        let impulse = direction * 5.21836
        
        ball.physicsBody?.mode = .dynamic
        
        //        ball.addForce(impulse, relativeTo: nil)
        
        
        ball.applyLinearImpulse(impulse, relativeTo: racquet)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.removeTheScene()
            self.appearsCongratsView()
        }
        
    }
    
    lazy var congrats1View: UIView = {
        let congratsView = UIView()
        congratsView.translatesAutoresizingMaskIntoConstraints = false
        congratsView.backgroundColor = UIColor.azulClaro
        congratsView.layer.cornerRadius = 10
            
        return congratsView
    }()
    
    func appearsCongratsView() {
        guard let arView = self.arView else {return}
        
        let stackView = UIStackView(arrangedSubviews: [congrats1View])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        arView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: arView.topAnchor, constant: 100),
            stackView.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -80),
            stackView.leadingAnchor.constraint(equalTo: arView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: arView.trailingAnchor, constant: -20),
        ])
        
    }
    
}
