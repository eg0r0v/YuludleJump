//
//  PlatformNode.swift
//  YuludleJump
//
//  Created by Илья Егоров on 19.02.2022.
//

import SpriteKit

enum PlatformState: Int, CaseIterable {
    case empty = 14 // 50%
    case hasCoin = 8 // 5/28
    case hasHeart = 1 // 1
    case hasGrass = 2
    case hasShell = 3
    
    private static let stateArray: [PlatformState] = {
        var array = [PlatformState]()
        for state in allCases {
            array.append(contentsOf: Array(repeating: state, count: state.rawValue))
        }
        return array
    }()
    
    static var randomElement: PlatformState {
        stateArray.randomElement() ?? .empty
    }
    
    var platformOffset: CGFloat {
        switch self {
        case .hasGrass, .hasShell:
            return PlatformNode.platformOffset
        default:
            return .zero
        }
    }
}

final class PlatformNode: SKSpriteNode {
    
    static let platformOffset: CGFloat = 8
    static let platformTextures: [SKTexture] = (1...4)
        .map({ .init(imageNamed: "platform-\($0)") })

    private static var randomTexture: SKTexture {
        let platformsCount = 4
        let randomPositionNumber = (0..<platformsCount).randomElement() ?? 0
        return PlatformNode.platformTextures[randomPositionNumber]
    }
    
    private(set) var isOneTimePlatform = false
    private(set) var platformState: PlatformState = .empty
    
    var platformItem: SKSpriteNode?
    
    init() {
        let texture = PlatformNode.randomTexture
        super.init(texture: texture,
                   color: .clear,
                   size: .init(width: 160, height: 40))
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func respawn() {
        texture = PlatformNode.randomTexture
        setupPhysicsBody()
    }
    
    private func setup() {
        zPosition = ZPositions.platform
        setupPhysicsBody()
    }
    
    private func setupPhysicsBody() {
        isOneTimePlatform = (0..<10).randomElement() == 0
        alpha = isOneTimePlatform ? 0.4 : 1.0
        
        platformState = PlatformState.randomElement
        
        platformItem?.removeFromParent()
        platformItem = nil
        
        var physicsBodySize = size
        physicsBodySize.height -= PlatformNode.platformOffset
        let physicsBodyPosition = CGPoint(x: 0, y: -PlatformNode.platformOffset / 2)
        physicsBody = .init(rectangleOf: physicsBodySize, center: physicsBodyPosition)
        physicsBody?.categoryBitMask = Physics.platform
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
    }
}
