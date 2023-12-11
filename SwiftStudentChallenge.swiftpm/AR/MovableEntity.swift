//
//  File.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 11/12/23.
//

import UIKit
import RealityKit

enum Shape {
    case box, sphere
}

class MovableEntity: Entity, HasModel, HasPhysics, HasCollision {
    
    var size: Float!
    var color: UIColor!
    var shape: Shape = .box
    var physicsMode: PhysicsBodyMode = .static
    
    init(size: Float, color: UIColor, shape: Shape, physicsMode: PhysicsBodyMode) {
        super.init()
        self.size = size
        self.color = color
        self.shape = shape
        self.physicsMode = physicsMode
        
        let mesh = generateMeshResource()
        let materials = [generateMaterial()]
        model = ModelComponent(mesh: mesh, materials: materials)
        
        physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: self.physicsMode)
        
        collision = CollisionComponent(shapes: [generateShapeResource()], mode: .trigger, filter: .sensor)
        
        generateCollisionShapes(recursive: true)
        
    }
    
    @MainActor required init() {
        fatalError("init() has not been implemented")
    }
    
    private func generateShapeResource() -> ShapeResource {
        
        switch shape {
        case .box:
            return ShapeResource.generateBox(size: [self.size, self.size, self.size])
        case .sphere:
            return ShapeResource.generateSphere(radius: self.size)
            
        }
        
    }
    
    private func generateMaterial() -> Material {
        SimpleMaterial(color: self.color, isMetallic: true)
    }
    
    private func generateMeshResource() -> MeshResource {
        
        switch shape {
        case .box:
            return MeshResource.generateBox(size: self.size)
        case .sphere:
            return MeshResource.generateSphere(radius: self.size)
        }
        
    }
    
    //  func moveAlongXAxis(distance: Float) {
    //    transform.translation.x += distance
    //  }
    
}
