//
//  GameScene.swift
//  YuludleJump
//
//  Created by Илья Егоров on 08.02.2022.
//

import SpriteKit
//import CoreMotion

final class GameScene: SKScene {
    
    private weak var gameDelegate: GameDelegate?

    private var backgroundNodes = [SKSpriteNode]()
    private var totalBackgroundHeight: CGFloat!
    
    private let octopus = OctopusNode()
    
    private var fishes = [FishNode]()
    private var platforms = [PlatformNode]()
    private var bubbles = [BubbleNode]()

    private let bottomNode = ResizedImages.bottomNode!
    
    private var gameStarted = false
    
    private let normalJumpSpeed: CGFloat = 1.2
    private let boostSpeed: CGFloat = 1.6
    
    private let topbarHeight: CGFloat = 40
    private var gameFrame: CGRect {
        let verticalOffset = (view?.safeAreaInsets.top ?? 0) + (view?.safeAreaInsets.bottom ?? 0)
        return .init(
            x: 0,
            y: view?.safeAreaInsets.bottom ?? 0,
            width: frame.width,
            height: frame.height - topbarHeight - verticalOffset
        )
    }
    
    private var lastTouchX: CGFloat = .zero
    
    init(size: CGSize, gameDelegate: GameDelegate?) {
        super.init(size: size)
        self.gameDelegate = gameDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        layout()
    }
    
    private func layout() {
        gameDelegate?.showScoreboard()
        addBackground()
        
        respawnOctopus()
        spawnFish()
        spawnBubbles()
        addBottomNode()
        addPlatforms()
    }
    
    private func addBackground() {
        backgroundNodes = ResizedImages.backgroundTextures.map ({
            let background = SKSpriteNode(texture: $0)
            background.zPosition = ZPositions.background
            addChild(background)
            return background
        })
        
        var offset = CGFloat.zero
        
        for background in backgroundNodes {
            background.position = .init(x: gameFrame.midX, y: background.size.height / 2 + offset)
            offset += background.size.height
        }
        
        totalBackgroundHeight = offset
    }
    
    private func respawnOctopus() {
        octopus.position = .init(x: gameFrame.midX, y: 50 + octopus.size.height)
        if octopus.parent == nil {
            addChild(octopus)
        }
    }
    
    private func spawnBubbles() {
        DispatchQueue.global().async { [weak self] in
            for _ in 1...50 {
                self?.bubbles.append(BubbleNode())
            }
        }
    }
    
    private func addBottomNode() {
        bottomNode.position = .init(x: bottomNode.size.width / 2, y: bottomNode.size.height / 2)
        addChild(bottomNode)
    }
    
    private func addPlatforms() {
        
        let platformRowsCount = 9
        let space = gameFrame.height / CGFloat(platformRowsCount)
        
        for column in 1..<platformRowsCount {
            let x = CGFloat.random(in: 0...gameFrame.width)
            let minY = gameFrame.minY + CGFloat(column) * space + 10
            let maxY = gameFrame.minY + CGFloat(column+1) * space - 10
            let y = CGFloat.random(in: minY...maxY)
            spawnPlatform(at: CGPoint(x: x, y: y))
        }
    }
    
    private func spawnFish() {
        let fishesCount = 1
        
        for _ in 0..<fishesCount {
            let fish = FishNode()
            
            let x = CGFloat.random(in: 0...gameFrame.width)
            let y = CGFloat.random(in: gameFrame.midY...gameFrame.maxY - 10)
            fish.position = .init(x: x, y: y)
            fishes.append(fish)
            
            addChild(fish)
        }
    }
    
    private func spawnPlatform(at position: CGPoint) {
        let platform = PlatformNode()
        platform.position = position
        platforms.append(platform)
        
        addChild(platform)
        addPlatformItem(platform: platform)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStarted {
            checkJumperPosition()
            checkJumperVelocity()
            updatePositions()
            
            updateBackground()
            updatePlatforms()
            updateFish()
            updateBubbles()
        }
        
        super.update(currentTime)
    }
    
    private func checkJumperPosition() {
        if octopus.position.y + octopus.size.height < 0 {
            takeHit()
            restartGameOnBottomHit()
            return
        }
        
        octopus.position.x = (octopus.position.x + gameFrame.width)
            .truncatingRemainder(dividingBy: gameFrame.width)
        
        for fish in fishes {
            fish.position.x = (fish.position.x + gameFrame.width)
                .truncatingRemainder(dividingBy: gameFrame.width)
        }
    }
    
    private func checkJumperVelocity() {
        if let octopusVelocity = octopus.physicsBody?.velocity.dx {
            octopus.physicsBody?.velocity.dx = min(max(octopusVelocity , -1000), 1000)
        }
    }
    
    private func restartGameOnBottomHit() {
        gameStarted = false
        physicsWorld.gravity = .zero
        octopus.physicsBody?.velocity = .zero
        respawnOctopus()
    }
    
    private func updatePositions() {
        guard let velocity = octopus.physicsBody?.velocity.dy else { return }
        
        let minimumHeight = gameFrame.midY
        
        let offset = velocity / 30
        
        guard octopus.position.y > minimumHeight && velocity > 0 else { return }
            
        [
            backgroundNodes,
            [bottomNode],
            platforms,
            platforms.compactMap(\.platformItem),
            fishes,
            bubbles
        ]
        .flatMap({ $0 })
        .forEach({
            $0.position.y -= offset
        })
    }
    
    private func updateBackground() {
        for background in backgroundNodes {
            if background.position.y + background.size.height / 2 < 0 {
                background.position.y += totalBackgroundHeight
            }
        }
        
        if bottomNode.frame.maxY < .zero {
            bottomNode.removeFromParent()
        }
    }
    
    private func updatePlatforms() {
        for platform in platforms {
            if platform.position.y < -platform.size.height - (platform.platformItem?.size.height ?? 0) {
                platform.respawn()
                platform.position.x = CGFloat.random(in: 0...gameFrame.width)
                platform.position.y = gameFrame.maxY + platform.size.height
                addPlatformItem(platform: platform)
            }
        }
    }
    
    private func updateFish() {
        for fish in fishes {
            fish.moveTo(point: octopus.position)
            if octopus.position.x < fish.position.x {
                fish.turnIfNeeded(to: .left)
            } else {
                fish.turnIfNeeded(to: .right)
            }
            fish.biteIfNeeded(targetPoint: octopus.position)
        }
    }
    
    private func updateBubbles() {
        for bubble in bubbles where bubble.isOnTheScreen {
            bubble.floatUp()
            if bubble.frame.minY > frame.height * 1.5 {
                bubble.removeFromParent()
                bubble.isOnTheScreen = false
            }
        }
    }
    
    private func addPlatformItem(platform: PlatformNode) {
        
        let platformItem: SKSpriteNode
        
        switch platform.platformState {
        case .hasCoin:
            platformItem = CoinNode()
        case .hasHeart:
            platformItem = HeartNode()
        case .hasGrass:
            platformItem = GrassNode()
        case .hasShell:
            platformItem = BoostNode()
        case .empty:
            return
        }
        
        platform.platformItem = platformItem
        platformItem.position.x = platform.position.x
        platformItem.position.y = platform.position.y + (platform.size.height + platformItem.size.height) / 2 - platform.platformState.platformOffset
        addChild(platformItem)
    }
    
    private func sendBubbles(boostNode: BoostNode) {
        guard let bubblesCount = (5...16).randomElement() else { return }
        
        for _ in 0..<bubblesCount {
            
            let bubbleNode: BubbleNode
            
            if let existingNode = bubbles.first(where: { !$0.isOnTheScreen }) {
                bubbleNode = existingNode
            } else {
                bubbleNode = BubbleNode()
                bubbles.append(bubbleNode)
            }
            
            bubbleNode.position.x = .random(in: boostNode.frame.minX - 10...boostNode.frame.maxX + 10)
            bubbleNode.position.y = .random(in: boostNode.frame.minY + 5...boostNode.frame.maxY + 10)
            bubbleNode.isOnTheScreen = true
            addChild(bubbleNode)
        }
    }
    
    private func takeHit() {
        gameDelegate?.livesLeft -= 1
        if gameDelegate?.livesLeft == 0 {
            endGame()
        }
    }
    
    private func endGame() {
        let menuScene = MenuScene(size: view!.bounds.size, gameDelegate: gameDelegate)
        view?.presentScene(menuScene)
        menuScene.setIsReady()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchX = touches.compactMap({ $0.location(in: view).x }).first ?? .zero
        
        if !gameStarted {
            physicsWorld.gravity = .init(dx: 0, dy: -5)
            octopus.physicsBody?.velocity.dy = gameFrame.height * normalJumpSpeed - octopus.position.y
            gameStarted.toggle()
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: view) else { return }
        
        let dx = location.x - lastTouchX
        
        octopus.position.x += dx
        octopus.turnIfNeeded(to: dx > 0 ? .right : .left)
        
        lastTouchX = location.x
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let velocity = octopus.physicsBody?.velocity.dy, velocity < 0 else { return }
        
        let contactMask =
            contact.bodyA.categoryBitMask |
            contact.bodyB.categoryBitMask
        
        switch contactMask {
        case Physics.octopus | Physics.platform:
            octopus.physicsBody?.velocity.dy = gameFrame.height * normalJumpSpeed - octopus.position.y
            if let platform = [contact.bodyA.node, contact.bodyB.node].compactMap({ $0 as? PlatformNode }).first {
                if platform.isOneTimePlatform {
                    platform.platformItem?.disappear()
                    platform.disappear()
                }
            }
        case Physics.octopus | Physics.boost:
            octopus.physicsBody?.velocity.dy = gameFrame.height * boostSpeed - octopus.position.y
            if let boost = [contact.bodyA.node, contact.bodyB.node].compactMap({ $0 as? BoostNode }).first {
                boost.activate()
                sendBubbles(boostNode: boost)
            }
        case Physics.octopus | Physics.fishEnemy:
            if let fish = [contact.bodyA.node, contact.bodyB.node].compactMap({ $0 as? FishNode }).first {
                takeHit()
                fish.takeRest()
            }
        case Physics.octopus | Physics.heart:
            gameDelegate?.livesLeft += 1
            if let heart = [contact.bodyA.node, contact.bodyB.node].compactMap({ $0 as? HeartNode }).first {
                heart.disappear()
            }
        case Physics.octopus | Physics.grassEnemy:
            
            if let grass = [contact.bodyA.node, contact.bodyB.node].compactMap({ $0 as? GrassNode }).first {
                if grass.readyToBite, let score = gameDelegate?.score {
                    let biteSize = 50
                    let newScore = score - biteSize + 1
                    gameDelegate?.score = max(0, (newScore - newScore % 10))
                    grass.takeRest()
                }
            }
        case Physics.octopus | Physics.coin:
            if let score = gameDelegate?.score {
                gameDelegate?.score = min(999, score + 10)
            }
            if let coin = [contact.bodyA.node, contact.bodyB.node].compactMap({ $0 as? CoinNode }).first {
                coin.disappear()
            }
        default:
            break
        }
    }
}
