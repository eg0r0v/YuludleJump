//
//  GameViewController.swift
//  YuludleJump
//
//  Created by Илья Егоров on 08.02.2022.
//

import UIKit
import GameplayKit

protocol GameDelegate: AnyObject {
    var livesLeft: Int { get set }
    var score: Int { get set }
    
    func showScoreboard()
    func hideScoreboard()
}

final class GameViewController: UIViewController {
    
    @IBOutlet private weak var scoreboardView: UIView!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var blurView: UIView!
    private let pauseLabel = UILabel()
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var livesLabel: UILabel!
    
    private let initialLivesLeftValue = 3
    
    lazy var livesLeft = initialLivesLeftValue {
        didSet {
            livesLabel.text = String(format: "%03d", livesLeft)
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = String(format: "%03d", score)
            
            let currentHighScore = UserDefaults.standard.integer(forKey: UserDefaultsKeys.highScoreKey)
            
            if score > currentHighScore {
                UserDefaults.standard.set(score, forKey: UserDefaultsKeys.highScoreKey)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreboardView.isHidden = true
        blurView.isHidden = true
        pauseLabel.isHidden = true
     
        setupPauseLabel()
        redrawScene()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(redrawScene),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    private func setupPauseLabel() {
        pauseLabel.text = "Pause".uppercased()
        pauseLabel.font = .systemFont(ofSize: 24, weight: .bold)
        pauseLabel.textColor = .white
        pauseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pauseLabel)
        NSLayoutConstraint.activate([
            pauseLabel.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            pauseLabel.centerYAnchor.constraint(equalTo: blurView.centerYAnchor)
        ])
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        redrawScene()
    }
    
    @objc private func redrawScene() {
        ResizedImages.configure(width: view.frame.width) { [weak self] in
            if let view = self?.view as? SKView, view.scene == nil {
                let menuScene = MenuScene(size: view.bounds.size, gameDelegate: self)
                menuScene.scaleMode = .aspectFill
                view.presentScene(menuScene)
                view.ignoresSiblingOrder = true
            }
            let currentScene = (self?.view as? SKView)?.scene
            (currentScene as? MenuScene)?.setIsReady()
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapPause(_ sender: Any) {
        var isPaused = !blurView.isHidden
        
        isPaused.toggle()
        
        let pauseImage = isPaused ? #imageLiteral(resourceName: "play") : #imageLiteral(resourceName: "pause")
        pauseButton.isUserInteractionEnabled = false
        pauseButton.setImage(pauseImage, for: .normal)
        
        if isPaused {
			Music.stopBackgroundMusic()
            blurView.isHidden = false
            pauseLabel.isHidden = false
            (view as? SKView)?.isPaused = isPaused
        }
        UIView.animate(
            withDuration: 0.3,
            animations: { [unowned self] in
                self.blurView.alpha = isPaused ? 0.6 : 0.0
                self.pauseLabel.alpha = isPaused ? 1.0 : 0.0
            }, completion: { [weak self] _ in
                if !isPaused {
					Music.playBackgroundMusic()
                    self?.blurView.isHidden = true
                    self?.pauseLabel.isHidden = true
                    (self?.view as? SKView)?.isPaused = isPaused
                }
                self?.pauseButton.isUserInteractionEnabled = true
            })
    }
}

extension GameViewController: GameDelegate {
    func showScoreboard() {
        scoreboardView.isHidden = false
        score = 0
        livesLeft = initialLivesLeftValue
    }
    
    func hideScoreboard() {
        scoreboardView.isHidden = true
    }
}
