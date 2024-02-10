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

class Coordinator: NSObject, ARSessionDelegate, ARCoachingOverlayViewDelegate {
    
    weak var arView: ARView?
    
    var cancellable: AnyCancellable?
    
    var ball: ModelEntity!
    var racquet: ModelEntity!
    var racquet2: ModelEntity!
    var court: ModelEntity!
    
    var modelsAdded: Bool = false
    
    var isFirstScene: Bool = true
    var hasFinished: Bool = false
    
    var modelEntity: ModelEntity?
    
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = arView?.session
        coachingOverlay.delegate = self
        arView?.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        buildTheScene(player1GameScore: 0, player2GameScore: 0)
    }
    
    func buildTheScene(player1GameScore: Int, player2GameScore: Int) {
        
        guard let view = arView else { return }
        
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
        
        let modelEntity = ModelEntity()
        self.modelEntity = modelEntity
        
        let player1Score = ModelEntity(mesh: MeshResource.generateText("Player 1:  \(player1GameScore)  6 3 2", extrusionDepth: 0.03, font: .systemFont(ofSize: 0.1), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .green, isMetallic: false)])
        
        player1Score.position = [-1.4, 1.2, 0]
        
        let player2Score = ModelEntity(mesh: MeshResource.generateText("Player 2: \(player2GameScore)  4 6 0", extrusionDepth: 0.03, font: .systemFont(ofSize: 0.1), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .red, isMetallic: false)])
        
        player2Score.position = [-1.4, 1, 0]
        
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
                entities[2].position = simd_make_float3(self.court.position.x - 0.3, self.court.position.y + 0.5, self.court.position.z + 1)
                
                entities[2].scale = [0.2, 0.2, 0.2]
                self.racquet = entities[2]
                
                
                // entities
                entities.forEach { entity in
                    modelEntity.addChild(entity)
                }
                
            })
        
        view.scene.addAnchor(anchor)
        
        modelEntity.addChild(player1Score)
        modelEntity.addChild(player2Score)
        anchor.addChild(modelEntity)
        
        view.installGestures(.scale.union(.translation), for: modelEntity)
        
        self.addPlayButton()
    }
    
    func removeTheScene() {
        guard let arView = self.arView else { return }
        
        for subview in arView.subviews {
            if let view = subview as? UIStackView {
                view.removeFromSuperview()
            }
        }
        
        arView.scene.anchors.removeAll()
    }
    
    lazy var playButton: UIButton = {
        let button = UIButton(configuration: .gray(), primaryAction: UIAction(handler: { [weak self] action in
            
            guard let arView = self?.arView else { return }
            
            guard let racquetPosition = self?.racquet.position else { return }
            guard let ballPosition = self?.ball.position else { return }
            
            // Calculate the direction from the ball to the racquet/
            let direction = racquetPosition / ballPosition
            
            // Apply an impulse to the ball in the calculated direction
            // 5.21836
            let impulse = direction
            
            self?.ball.physicsBody?.mode = .dynamic
            
            self?.ball.applyLinearImpulse([0,0,0.0095], relativeTo: self?.ball.parent)
            
            //  ------ Audio --------
            guard let path = Bundle.main.path(forResource: "ballSound 7", ofType:
                                                "m4a") else { fatalError("Error loading audio file") }
            
            let url = URL(fileURLWithPath: path)
            
            self?.cancellable = AudioFileResource.loadAsync(contentsOf: url, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
                .collect()
                .sink(receiveCompletion: { loadCompletion in
                    if case let .failure(error) = loadCompletion {
                        print("Unable to load model \(error)")
                    }
                    
                    self?.cancellable?.cancel()
                    
                }, receiveValue: { resources in
                    
                    resources.forEach { resource in
                        self?.modelEntity?.playAudio(resource)
                    }
                    
                })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5 /*7*/) {
                self?.removeTheScene()
                
                if self?.isFirstScene == true {
                    self?.buildCongratsViews(title: Texts.congratulation, text: Texts.congratstTextOne, textButton: Texts.nextPoint, hideImage: true, hideButton: false)
                    self?.isFirstScene = false
                } else {
                    self?.buildCongratsViews(title: Texts.thankYou, text: Texts.congratsTextFinal, textButton: "", hideImage: false, hideButton: true)
                    self?.hasFinished = true
                }
            }
            
        }))
        
        button.setTitle(Texts.play, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func addPlayButton() {
        guard let arView = self.arView else { return }
        
        let stackView = UIStackView(arrangedSubviews: [playButton])
        
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        arView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -60),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    //    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
    //
    //        guard let arView = self.arView else { return }
    //
    //        let tapLocation = recognizer.location(in: arView)
    //
    //        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
    //
    //        if results.first != nil {
    //            if modelsAdded == false {
    //                buildTheScene(playerScore: 0, opponentScore: 0)
    //                self.modelsAdded = true
    //            } else {
    //
    //            }
    //        }
    //
    //    }
    
    lazy var congratsTitle: UILabel = {
        let textLabel = UILabel()
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.isAccessibilityElement = true
        textLabel.textAlignment = .center
        textLabel.font = UIFont.boldSystemFont(ofSize:  UIFont.preferredFont(forTextStyle: .title1).pointSize)
        textLabel.lineBreakMode = .byWordWrapping
        
        return textLabel
    }()
    
    lazy var congratsText: UILabel = {
        let textLabel = UILabel()
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.isAccessibilityElement = true
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = UIFont.boldSystemFont(ofSize:  UIFont.preferredFont(forTextStyle: .title2).pointSize)
        textLabel.lineBreakMode = .byWordWrapping
        
        return textLabel
    }()
    
    lazy var buttonNext: UIButton = {
        let button = UIButton(configuration: .gray(), primaryAction: UIAction(handler: { [weak self] action in
            
            guard let arView = self?.arView else { return }
            
            self?.removeTheScene()
            
            if self?.hasFinished == false {
                self?.buildTheScene(player1GameScore: 30, player2GameScore: 40)
            } else {
                //                self?.buildCongratsViews(title: Texts.thankYou, text: Texts.congratsTextFinal, textButton: "", hideImage: false, hideButton: true)
            }
            
        }))
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func buildCongratsViews(title: String, text: String, textButton: String, hideImage: Bool, hideButton: Bool) {
        guard let arView = self.arView else {return}
        
        let stackView = UIStackView(arrangedSubviews: [congratsTitle, ballImage , congratsText, buttonNext])
        
        congratsTitle.text = title
        congratsText.text = text
        buttonNext.setTitle(textButton, for: .normal)
        
        buttonNext.isHidden = hideButton
        ballImage.isHidden = hideImage
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = UIColor.myBlue
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 25, left: 25, bottom: 30, right: 25)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        arView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: arView.topAnchor, constant: 150),
            stackView.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -150),
            stackView.leadingAnchor.constraint(equalTo: arView.leadingAnchor, constant: 150),
            stackView.trailingAnchor.constraint(equalTo: arView.trailingAnchor, constant: -150),
        ])
        
    }
    
    lazy var ballImage: UIImageView = {
        let ballImage = UIImageView(image: UIImage(named: Texts.ballImageName))
        
        ballImage.translatesAutoresizingMaskIntoConstraints = false
        
        return ballImage
    }()
    
    //    func buildCreditsView() {
    //        guard let arView = self.arView else { return }
    //
    //        let stackView = UIStackView(arrangedSubviews: [congratsTitle, ballImage, congratsText])
    //
    //        congratsTitle.text = Texts.IloveTennis
    //        congratsText.text = Texts.finalText
    //
    //        stackView.axis = .vertical
    //        stackView.distribution = .equalSpacing
    //        stackView.alignment = .center
    //        stackView.backgroundColor = UIColor.myBlue
    //        stackView.layer.cornerRadius = 10
    //        stackView.isLayoutMarginsRelativeArrangement = true
    //        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 60, right: 15)
    //        stackView.translatesAutoresizingMaskIntoConstraints = false
    //
    //        arView.addSubview(stackView)
    //
    //        NSLayoutConstraint.activate([
    //            stackView.topAnchor.constraint(equalTo: arView.topAnchor, constant: 150),
    //            stackView.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -150),
    //            stackView.leadingAnchor.constraint(equalTo: arView.leadingAnchor, constant: 150),
    //            stackView.trailingAnchor.constraint(equalTo: arView.trailingAnchor, constant: -150),
    //        ])
    //        
    //    }
    
}
