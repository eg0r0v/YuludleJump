//
//  OctopusNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 19.02.2022.
//

import SpriteKit

final class OctopusNode: SKSpriteNode {
    
    enum Position: Int {
        case left
        case right
        
        fileprivate var texture: SKTexture {
            switch self {
            case .left:
                return .init(image: #imageLiteral(resourceName: "octopus-l"))
            case .right:
                return .init(image: #imageLiteral(resourceName: "octopus-r"))
            }
        }
    }
    
    private var octopusPosition: Position = .left
    
    init() {
        super.init(texture: Position.left.texture,
                   color: .clear,
                   size: .init(width: 40, height: 60))
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        name = "Octopus"
        zPosition = ZPositions.octopus
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = Physics.octopus
        physicsBody?.contactTestBitMask = Physics.platform | Physics.boost | Physics.collectable | Physics.enemy
        physicsBody?.collisionBitMask = Physics.none
    }
    
    func turnIfNeeded(to newPosition: Position) {
        guard newPosition != octopusPosition else { return }
        octopusPosition = newPosition
        texture = octopusPosition.texture
    }
    
}
