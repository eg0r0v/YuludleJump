//
//  BoostNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 19.02.2022.
//

import SpriteKit

final class BoostNode: SKSpriteNode {

    static let boostTextures: [SKTexture] = {
        
        return stride(from: 6, to: 0, by: -1)
            .reduce(into: [7]) { $0 = [$1] + $0 + [$1] }
            .compactMap({ UIImage(named: "shell-\($0)") })
            .map({ SKTexture(image: $0) })
    }()
    
    init() {
        let texture = SKTexture(image: #imageLiteral(resourceName: "shell-1"))
        super.init(texture: texture, color: .clear, size: .init(width: 60, height: 30))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        name = "Boost"
        zPosition = ZPositions.boost
        physicsBody = .init(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = Physics.boost
        physicsBody?.contactTestBitMask = Physics.octopus
        physicsBody?.collisionBitMask = Physics.none
    }
    
    func activate() {
        run(.animate(with: BoostNode.boostTextures, timePerFrame: 0.07))
    }
}
