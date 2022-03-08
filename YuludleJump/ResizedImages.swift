//
//  ResizedImages.swift
//  YuludleJump
//
//  Created by Илья Егоров on 08.03.2022.
//

import SpriteKit

final class ResizedImages {

    static private(set) var bottomNode: BottomNode!
    static private(set) var backgroundTextures: [SKTexture]!
    
    static func configure(width: CGFloat, completion: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            let image = #imageLiteral(resourceName: "bottom").resized(width: width)
            self.bottomNode = .init(image: image)
            
            self.backgroundTextures = (1...3).compactMap {
                UIImage(named: "background-\($0)")?.resized(width: width)
            }.map {
                SKTexture(image: $0)
            }
            
            _ = PlatformNode.platformTextures
            _ = BoostNode.boostTextures
            _ = FishNode.leftBiteTextures
            _ = FishNode.rightBiteTextures
            _ = HeartNode.heartTextures
            _ = CoinNode.coinTextures
            _ = BubbleNode.bubbleTextures
            
            DispatchQueue.main.async(execute: completion)
        }
    }
}
