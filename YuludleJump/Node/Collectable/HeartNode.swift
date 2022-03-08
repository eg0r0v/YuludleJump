//
//  HeartNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 19.02.2022.
//

import SpriteKit

final class HeartNode: SKSpriteNode, AnimatingNode {
    
    let frameTime: TimeInterval = 0.07
    
    static let heartTextures: [SKTexture] = (1...7)
        .compactMap({ UIImage(named: "heart-\($0)") })
        .map({ SKTexture(image: $0) })
    
    var textures: [SKTexture] { HeartNode.heartTextures }
    
    init(shouldRotate: Bool = true) {
        super.init(texture: .init(image: #imageLiteral(resourceName: "heart-1")),
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
        name = "Heart"
        zPosition = ZPositions.collectable
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = Physics.heart
        physicsBody?.contactTestBitMask = Physics.octopus
        physicsBody?.collisionBitMask = Physics.none
    }
}
