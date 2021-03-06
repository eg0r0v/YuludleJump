//
//  GameViewController.swift
//  YuludleJump
//
//  Created by Илья Егоров on 08.02.2022.
//

import UIKit
import SpriteKit
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
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var livesLabel: UILabel!
    
    var livesLeft = 3 {
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
        
        ResizedImages.configure(width: view.frame.width) { [weak self] in
            let menuScene = (self?.view as? SKView)?.scene as? MenuScene
            menuScene?.setIsReady()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        if let view = self.view as? SKView {
            
            let menuScene = MenuScene(size: view.bounds.size, gameDelegate: self)
            
            menuScene.scaleMode = .aspectFill
            
            view.presentScene(menuScene)
            
            view.ignoresSiblingOrder = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
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
            self.blurView.isHidden = false
            (view as? SKView)?.isPaused = isPaused
        }
        UIView.animate(
            withDuration: 0.3,
            animations: { [unowned self] in
                self.blurView.alpha = isPaused ? 0.6 : 0.0
            }, completion: { [weak self] _ in
                if !isPaused {
                    self?.blurView.isHidden = true
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
        livesLeft = 3
    }
    
    func hideScoreboard() {
        scoreboardView.isHidden = true
    }
}
