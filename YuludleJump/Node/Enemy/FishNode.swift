//
//  FishNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 19.02.2022.
//

import SpriteKit

final class FishNode: SKSpriteNode {

    enum Position: Int {
        case left
        case right
        
        fileprivate var texture: SKTexture {
            switch self {
            case .left:
                return .init(image: #imageLiteral(resourceName: "fish-l-1"))
            case .right:
                return .init(image: #imageLiteral(resourceName: "fish-r-1"))
            }
        }
    }
    
    private let fishSpeed: CGFloat = floor(UIScreen.main.bounds.height / 240)
    private var enemyPosition: Position = .left
    private var readyToBite = true
    private var isBitingAnimated = false
    
    private static let fishSize = CGSize(width: 90, height: 60)
    
    static let leftBiteTextures: [SKTexture] = (1...7)
        .compactMap({ UIImage(named: "fish-l-\($0)") })
        .map({ SKTexture(image: $0) })
    
    static let rightBiteTextures: [SKTexture] = (1...7)
        .compactMap({ UIImage(named: "fish-r-\($0)") })
        .map({ SKTexture(image: $0) })
    
    private var frameTicker = 0
    
    private let leftPhysicsBody: SKPhysicsBody = {
        let physicsBodySize = CGSize(width: fishSize.width / 2, height: fishSize.height)
        let physicsBodyCenter = CGPoint(x: -physicsBodySize.width / 2, y: 0)
        let physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize, center: physicsBodyCenter)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = Physics.fishEnemy
        physicsBody.contactTestBitMask = Physics.octopus
        physicsBody.collisionBitMask = Physics.none
        return physicsBody
    }()
    
    private let rightPhysicsBody: SKPhysicsBody = {
        let physicsBodySize = CGSize(width: fishSize.width / 2, height: fishSize.height)
        let physicsBodyCenter = CGPoint(x: physicsBodySize.width / 2, y: 0)
        let physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize, center: physicsBodyCenter)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = Physics.fishEnemy
        physicsBody.contactTestBitMask = Physics.octopus
        physicsBody.collisionBitMask = Physics.none
        return physicsBody
    }()
    
    init() {
        super.init(texture: Position.left.texture, color: .clear, size: FishNode.fishSize)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        name = "Fish"
        zPosition = ZPositions.enemy
        updatePhysicsBody()
    }
    
    func takeRest() {
        readyToBite = false
        physicsBody?.contactTestBitMask = Physics.none
        physicsBody?.categoryBitMask = Physics.none
        
        alpha = 0.6
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.readyToBite = true
            self?.alpha = 1.0
            self?.physicsBody?.categoryBitMask = Physics.fishEnemy
            self?.physicsBody?.contactTestBitMask = Physics.octopus
        }
    }
    
    func turnIfNeeded(to newPosition: Position) {
        guard readyToBite, newPosition != enemyPosition else { return }
        enemyPosition = newPosition
        texture = enemyPosition.texture
        updatePhysicsBody()
    }
    
    private func updatePhysicsBody() {
        let contactMask = physicsBody?.contactTestBitMask
        let categoryBitMask = physicsBody?.categoryBitMask
        
        physicsBody = enemyPosition == .left ? leftPhysicsBody : rightPhysicsBody
        if let contactMask = contactMask {
            physicsBody?.contactTestBitMask = contactMask
        }
        if let categoryBitMask = categoryBitMask {
            physicsBody?.categoryBitMask = categoryBitMask
        }
    }
    
    func moveTo(point: CGPoint) {
        guard readyToBite else { return }
        let speed = position.y < -size.height ? fishSpeed * 2 : fishSpeed
        let newVector = CGVector(dx: point.x - position.x, dy: point.y - position.y).with(length: speed)
        position.x += newVector.dx
        position.y += newVector.dy
    }
    
    func biteIfNeeded(targetPoint: CGPoint) {
        let distance = CGVector(dx: targetPoint.x - position.x, dy: targetPoint.y - position.y).length
        
        if distance < 300 {
            startBiting()
        } else {
            stopBiting()
        }
    }
}

private extension FishNode {
    
    func startBiting() {
        guard !isBitingAnimated else { return }
        isBitingAnimated = true
        
        if frameTicker == 0 {
            biteAnimate()
        }
    }
    
    func stopBiting() {
        guard isBitingAnimated else { return }
        isBitingAnimated = false
    }
    
    func biteAnimate() {
        let frameTime: TimeInterval = 0.07
        
        let textureArray = enemyPosition == .left ? FishNode.leftBiteTextures : FishNode.rightBiteTextures
        
        frameTicker = (frameTicker + 1) % textureArray.count
        texture = textureArray[frameTicker]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + frameTime) { [weak self] in
            guard let self = self else { return }
            if self.isBitingAnimated || self.frameTicker != 0 {
                self.biteAnimate()
            }
        }
    }
}
