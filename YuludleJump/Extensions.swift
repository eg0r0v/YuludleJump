//
//  Extensions.swift
//  YuludleJump
//
//  Created by Илья Егоров on 19.02.2022.
//

import SpriteKit

protocol AnimatingNode: SKSpriteNode {
    var textures: [SKTexture] { get }
    var frameTime: TimeInterval { get }
    func startAnimation()
}

extension AnimatingNode {
    func startAnimation() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.run(.repeatForever(.animate(with: self.textures, timePerFrame: self.frameTime)))
        }
        
    }
}

extension SKSpriteNode {
    func disappear() {
        physicsBody?.categoryBitMask = Physics.none
        run(SKAction.fadeOut(withDuration: 0.5))
    }
}

extension UIColor {
    static var blueNavbar: UIColor { return UIColor(named: #function)! }
}

extension UIImage {
    func resized(width: CGFloat) -> UIImage {
        let rate = width / size.width
        let newSize = CGSize(width: width, height: floor(size.height * rate))
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension CGVector {
    var length: CGFloat { sqrt(dx * dx + dy * dy) }
    
    var normalized: CGVector {
        return .init(dx: dx / length, dy: dy / length)
    }
    
    func sum(vector: CGVector) -> CGVector {
        return .init(dx: (dx + vector.dx) / 2, dy: (dy + vector.dy) / 2)
    }
    
    func with(length: CGFloat) -> CGVector {
        let short = normalized
        return .init(dx: short.dx * length, dy: short.dy * length)
    }
}
