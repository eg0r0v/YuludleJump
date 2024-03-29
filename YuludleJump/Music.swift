//
//  Music.swift
//  YuludleJump
//
//  Created by Илья Егоров on 29.03.2024.
//

import SpriteKit
import AVFoundation

final class Music {
	private static let audioPlayer: AVAudioPlayer? = {
		guard let path = Bundle.main.path(forResource: "mainTheme.mp3", ofType: nil) else { return nil }
		let url = URL(fileURLWithPath: path)
		let player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: "mp3")
		player?.numberOfLoops = -1
		return player
	}()
	
	private init() {
		
	}
	
	static func playBackgroundMusic() {
		audioPlayer?.play()
	}
	
	static func stopBackgroundMusic() {
		audioPlayer?.stop()
		audioPlayer?.currentTime = .zero
	}
	
	static let collectCoinSound = SKAction.playSoundFileNamed("coinCollect.mp3", waitForCompletion: false)
	static let jumpSound = SKAction.playSoundFileNamed("jump.mp3", waitForCompletion: false)
	static let newLifeSound = SKAction.playSoundFileNamed("newLife.mp3", waitForCompletion: false)
	static let shellBubblesSound = SKAction.playSoundFileNamed("shellBubbles.mp3", waitForCompletion: false)
	static let fishHitSound = SKAction.playSoundFileNamed("fishHit.mp3", waitForCompletion: false)
	static let grassHitSound = SKAction.playSoundFileNamed("grassHit.mp3", waitForCompletion: false)
}
