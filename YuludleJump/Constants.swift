//
//  Constants.swift
//  YuludleJump
//
//  Created by Илья Егоров on 08.02.2022.
//

import struct SpriteKit.CGFloat

enum Physics {
    static let none: UInt32 = 0
    static let octopus: UInt32 = 0x1
    static let platform: UInt32 = 0x1 << 1
    static let fishEnemy: UInt32 = 0x1 << 2
    static let grassEnemy: UInt32 = 0x1 << 3
    static let boost: UInt32 = 0x1 << 4
    static let heart: UInt32 = 0x1 << 5
    static let coin: UInt32 = 0x1 << 6
    
    static let enemy = grassEnemy | fishEnemy
    static let collectable = heart | coin
}

enum ZPositions {
    static let background: CGFloat = -1
    static let platform: CGFloat = 0
    static let bottom: CGFloat = 1
    static let octopus: CGFloat = 5
    static let enemy: CGFloat = 4
    static let boost: CGFloat = 2
    static let collectable: CGFloat = 3
    
    static let menuBackground: CGFloat = 100
    static let menuItem: CGFloat = 101
}

enum UserDefaultsKeys {
    static let highScoreKey = "yuludle.highscore"
}
