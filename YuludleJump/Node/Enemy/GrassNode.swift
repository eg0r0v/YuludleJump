//
//  GrassNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 19.02.2022.
//

import SpriteKit

final class GrassNode: SKSpriteNode {

    private(set) var readyToBite = true
    
    init() {
        let texture = SKTexture(image: #imageLiteral(resourceName: "grass"))
        super.init(texture: texture, color: .clear, size: .init(width: 60, height: 90))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        name = "Grass"
        zPosition = ZPositions.enemy
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = Physics.grassEnemy
        physicsBody?.contactTestBitMask = Physics.octopus
        physicsBody?.collisionBitMask = Physics.none
    }
    
    func takeRest() {
        guard readyToBite else { return }
        readyToBite = false
        
        alpha = 0.6
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.alpha = 1.0
            self?.readyToBite = true
        }
    }
}
