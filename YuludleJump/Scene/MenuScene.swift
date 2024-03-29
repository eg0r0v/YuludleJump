//
//  MenuScene.swift
//  YuludleJump
//
//  Created by Илья Егоров on 08.02.2022.
//

import SpriteKit

final class MenuScene: SKScene {
    
    private weak var gameDelegate: GameDelegate?
    
    init(size: CGSize, gameDelegate: GameDelegate?) {
        super.init(size: size)
        self.gameDelegate = gameDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        gameDelegate?.hideScoreboard()
        
        addBackground()
		
		Music.stopBackgroundMusic()
        
        isUserInteractionEnabled = false
        
        super.didMove(to: view)
    }
    
    func setIsReady() {
        isUserInteractionEnabled = true
        addStartGameLabels()
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background-1")
        let size = background.texture!.size()
        let rate = frame.width / size.width
        background.size = CGSize(width: frame.width, height: size.height * rate)
        background.position = .init(x: frame.midX, y: background.size.height / 2)
        background.zPosition = ZPositions.background
        addChild(background)
    }
    
    private func addStartGameLabels() {
        
        let startGameNode = SKSpriteNode(imageNamed: "startGame")
        startGameNode.size = .init(width: 200, height: 90)
        startGameNode.position = .init(x: frame.midX, y: frame.midY)
        startGameNode.zPosition = 1
        addChild(startGameNode)
        
        let highscore = UserDefaults.standard.integer(forKey: UserDefaultsKeys.highScoreKey)
        let highScoreLabel = SKLabelNode(text: "Highscore: \(highscore)")
        highScoreLabel.fontName = "HelveticaNeue"
        highScoreLabel.fontSize = 18
        
        highScoreLabel.position = .init(x: frame.midX, y: frame.midY - 90)
        highScoreLabel.zPosition = 1
        addChild(highScoreLabel)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let size = view?.bounds.size else { return }
        let gameScene = GameScene(size: size, gameDelegate: gameDelegate)
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene)
    }
}
