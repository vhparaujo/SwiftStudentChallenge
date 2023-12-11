//
//  File.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 11/12/23.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        // Set up a pan gesture recognizer
        //    let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        //          arView.addGestureRecognizer(panGesture)
        
        
        
        context.coordinator.arView = arView
        context.coordinator.buildEnvironment()
        arView.session.delegate = context.coordinator
        
        //arView.addCoaching()
        
        return arView
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}


extension ARView: ARCoachingOverlayViewDelegate {
    
    private func addVirtualObjects() {
        
    }
    
    func addCoaching() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        self.addSubview(coachingOverlay)
        
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        addVirtualObjects()
    }
    
}
