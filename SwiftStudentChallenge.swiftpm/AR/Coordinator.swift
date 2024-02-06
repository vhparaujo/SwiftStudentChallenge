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
import AVFoundation

// TODO: implementar audio se conseguir.
// TODO: implementar o foco da quadra, para saber onde clicar antes de clicar para aparecer as entidades.
// TODO: Finalizar as views intermediarias, pedir ajuda para o leo para centralizar os textos e diminuir as distancias entre eles.
// TODO: Finalizar a view de créditos.

class Coordinator: NSObject, ARSessionDelegate {
    
    weak var arView: ARView?
    
    var cancellable: AnyCancellable?
    
    var ball: ModelEntity!
    var racquet: ModelEntity!
    var racquet2: ModelEntity!
    var court: ModelEntity!
    
    var modelsAdded: Bool = false
    
    var isFirstScene: Bool = true
    var hasFinished: Bool = false
    
    func buildTheScene(playerScore: Int, opponentScore: Int) {
        
        guard let view = arView else { return }
      
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
        
        let modelEntity = ModelEntity()
        
        let score = ModelEntity(mesh: MeshResource.generateText("Score: \(playerScore) X \(opponentScore)", extrusionDepth: 0.03, font: .systemFont(ofSize: 0.09), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .blue, isMetallic: false)])
        
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
            let direction = normalize(racquetPosition - ballPosition)
            
            // Apply an impulse to the ball in the calculated direction
            let impulse = direction * 5.21836
            
            self?.ball.physicsBody?.mode = .dynamic
            
            self?.ball.applyLinearImpulse(impulse, relativeTo: self?.racquet)
            
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //                guard let path = Bundle.main.path(forResource: "ballSound 7", ofType:
            //                "m4a") else { fatalError("Error loading audio file") }
            //
            //                let url = URL(fileURLWithPath: path)
            //
            //                self?.cancellable = AudioFileResource.loadAsync(contentsOf: url, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
            //                    .collect()
            //                    .sink(receiveCompletion: { loadCompletion in
            //                        if case let .failure(error) = loadCompletion {
            //                            print("Unable to load model \(error)")
            //                        }
            //
            //                        self?.cancellable?.cancel()
            //
            //                    }, receiveValue: { resources in
            //
            //                        resources.forEach { resource in
            //                            self?.modelEntity.playAudio(resource)
            //                        }
            //
            //                    })
            //            }
            
            #warning("voltar o tempo para 7 segundos")
            DispatchQueue.main.asyncAfter(deadline: .now() + 7 /*7*/) {
                self?.removeTheScene()
                
                if self?.isFirstScene == true {
                    self?.buildCongratsViews(title: Texts.congratulation, text: Texts.congratstTextOne, textButton: Texts.nextPoint)
                    self?.isFirstScene = false
                } else {
                    self?.buildCongratsViews(title: Texts.congratulation, text: Texts.congratsTextTwo, textButton: Texts.finish)
                    self?.hasFinished = true
                }
            }
            
        }))
        
        button.setTitle(Texts.play, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
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
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        guard let arView = self.arView else {return}
        
        let tapLocation = recognizer.location(in: arView)
        
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
                
        if results.first != nil {
            if modelsAdded == false {
                buildTheScene(playerScore: 0, opponentScore: 0)
                self.modelsAdded = true
            } else {
                
            }
        }
        
    }
    
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
        textLabel.font = .preferredFont(forTextStyle: .headline)
        textLabel.lineBreakMode = .byWordWrapping
        
        return textLabel
    }()
    
    lazy var buttonNext: UIButton = {
        let button = UIButton(configuration: .gray(), primaryAction: UIAction(handler: { [weak self] action in
            
            guard let arView = self?.arView else { return }
            
            for subview in arView.subviews {
                if let view = subview as? UIStackView {
                    view.removeFromSuperview()
                }
            }
            
            if self?.hasFinished == false {
                self?.buildTheScene(playerScore: 40, opponentScore: 30)
            } else {
                self?.buildCreditsView()
            }
            
        }))
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func buildCongratsViews(title: String, text: String, textButton: String) {
        guard let arView = self.arView else {return}
        
        let stackView = UIStackView(arrangedSubviews: [congratsTitle, congratsText, buttonNext])
        
        congratsTitle.text = title
        congratsText.text = text
        buttonNext.setTitle(textButton, for: .normal)
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = UIColor.myBlue
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 60, right: 15)
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
    
    func buildCreditsView() {
        guard let arView = self.arView else { return }
        
        let stackView = UIStackView(arrangedSubviews: [congratsTitle, ballImage, congratsText])
        
#warning("colocar os textos na struct Texts")
        congratsTitle.text = "I love Tennis"
        congratsText.text = "Thank you o much for help me and make company for me in this journal."
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.backgroundColor = UIColor.myBlue
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        arView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: arView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: arView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: arView.trailingAnchor)
        ])
        
    }
    
}
