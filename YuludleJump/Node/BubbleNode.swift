//
//  BubbleNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 06.03.2022.
//

import SpriteKit

final class BubbleNode: SKSpriteNode {
    
    var isOnTheScreen = false
    
    static let bubbleTextures: [SKTexture] = (4...18).map {
        let image = UIImage(named: "bubble")!.resized(width: CGFloat($0))
        return SKTexture(image: image)
    }
    
    init() {
        let texture = BubbleNode.bubbleTextures.randomElement()!
        super.init(texture: texture, color: .clear, size: texture.size())
        
        alpha = 0.69
        zPosition = ZPositions.enemy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func floatUp() {
        position.y += 4
        position.x += CGFloat((-2...2).randomElement() ?? 0)
    }
}
