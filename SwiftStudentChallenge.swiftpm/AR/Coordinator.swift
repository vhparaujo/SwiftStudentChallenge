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
    
    //var movableEntities = [MovableEntity]()
    
    var sphere: MovableEntity!
    var box1: MovableEntity!
    var floor: ModelEntity!
    
    var initialPanPosition: CGPoint = .zero
    
    func buildEnvironment() {
        guard let view = arView else { return }
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        floor = ModelEntity(mesh: MeshResource.generatePlane(width: 2, depth: 3.2), materials: [OcclusionMaterial()])
        floor.generateCollisionShapes(recursive: true)
        floor.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
        floor.position.y = -0.01
        
        cancellable = ModelEntity.loadAsync(named: "tennisCourt")
            .sink(receiveCompletion: { loadCompletion in
                if case let .failure(error) = loadCompletion {
                    print("Unable to load model \(error)")
                }
                
                self.cancellable?.cancel()
                
            }, receiveValue: { entity in
                
                
                //        let parentEntity = ModelEntity()
                //                 parentEntity.addChild(entity)
                //
                //                 let entityBounds = entity.visualBounds(relativeTo: parentEntity)
                //                 parentEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
                //
                //
                //        entity.generateCollisionShapes(recursive: true)
                //          view.installGestures(.all, for: entity)
                
                anchor.addChild(entity)
                
                //        self.floor.scale = entity.scale
                //        self.floor.position = entity.position
                
                
            })
        
        box1 = MovableEntity(size: 0.2, color: .purple, shape: .box, physicsMode: .static)
        box1.position = simd_make_float3(floor.position.x, floor.position.y + 0.7, floor.position.z + 1)
        
        sphere = MovableEntity(size: 0.1, color: .red, shape: .sphere, physicsMode: .static)
        sphere.position = simd_make_float3(floor.position.x, floor.position.y + 1.5, floor.position.z + -0.5) // Adjust the position based on your scene
        
        sphere.name = "ball"
        
        anchor.addChild(sphere)
        anchor.addChild(box1)
        anchor.addChild(floor)
        
        view.scene.addAnchor(anchor)
        view.installGestures(.all, for: box1)
        
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        guard let view = self.arView else {return}
        
        // this guard let check if doesn't exist an object in the scene with the name "ball"
        guard view.scene.anchors.first(where: { $0.name == "ball" }) == nil else {
            return
        }
        
        let tapLocation = recognizer.location(in: view)
        
        if let entity = view.entity(at: tapLocation) as? MovableEntity {
            sphere.physicsBody?.mode = .dynamic
            
            // Calculate the direction from the camera to box1
            let direction = normalize(box1.position)
            
            // Apply an impulse to the sphere in the calculated direction
            let impulse = direction * 2.8 // Adjust the magnitude as needed
            sphere.applyLinearImpulse(impulse, relativeTo: box1)
        }
    }
    
    //  @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    //
    //    guard let view = self.arView else {return}
    //
    //    switch gesture.state {
    //    case .began:
    //      // Save the initial position of the pan gesture
    //      initialPanPosition = gesture.location(in: view)
    //
    //    case .changed:
    //      // Calculate the distance based on the change in x-position of the pan gesture
    //      let currentPanPosition = gesture.location(in: view)
    //      let distance = Float(currentPanPosition.x - initialPanPosition.x) * 0.001 // Adjust the multiplier as needed
    //
    //      // Move the entity along the x-axis
    //      box1.moveAlongXAxis(distance: distance)
    //
    //      // Update the initial position for the next iteration
    //      initialPanPosition = currentPanPosition
    //
    //    default:
    //      break
    //    }
    //  }
    
}

