//
//  CoinNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 19.02.2022.
//

import SpriteKit

final class CoinNode: SKSpriteNode, AnimatingNode {
    
    let frameTime: TimeInterval = 0.07
    
    static let coinTextures: [SKTexture] = (1...14)
        .compactMap({ UIImage(named: "coin-\($0)") })
        .map({ SKTexture(image: $0) })
    
    var textures: [SKTexture] { CoinNode.coinTextures }
    
    init(shouldRotate: Bool = true) {
        super.init(texture: .init(image: #imageLiteral(resourceName: "coin-1")),
                   color: .clear,
                   size: .init(width: 28, height: 28))
        
        setup()
        
        if shouldRotate {
            startAnimation()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        name = "Coin"
        zPosition = ZPositions.collectable
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = Physics.coin
        physicsBody?.contactTestBitMask = Physics.octopus
        physicsBody?.collisionBitMask = Physics.none
    }
}
