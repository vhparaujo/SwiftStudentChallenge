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
      
    arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:))))
      
      let config = ARWorldTrackingConfiguration()
      config.planeDetection = [.horizontal, .vertical]
      config.environmentTexturing = .automatic
      
      if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
          config.sceneReconstruction = .mesh
      }
      
      arView.session.run(config)
      arView.addCoachingOverlay()
      
    context.coordinator.arView = arView
    context.coordinator.buildFirstScene()
   
    arView.session.delegate = context.coordinator
      
    return arView
    
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator()
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
      
  }
  
}


extension ARView: ARCoachingOverlayViewDelegate {
    
    func addCoachingOverlay() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        self.addSubview(coachingOverlay)
        
    }
    
}
