//
//  BottomNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 06.03.2022.
//

import SpriteKit

final class BottomNode: SKSpriteNode {
    
    init(image: UIImage) {
        
        super.init(
            texture: .init(image: image),
            color: .clear,
            size: image.size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        zPosition = ZPositions.bottom
        
        let topOffset = size.height * 0.31
        var physicsBodySize = size
        physicsBodySize.height -= topOffset
        let physicsBodyPosition = CGPoint(x: 0, y: -topOffset / 2)
        physicsBody = .init(rectangleOf: physicsBodySize, center: physicsBodyPosition)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = Physics.platform
    }
}
