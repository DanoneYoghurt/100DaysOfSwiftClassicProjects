//
//  GameScene.swift
//  milestone 6
//
//  Created by Антон Баскаков on 24.09.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameTimer: Timer?
    
    var target: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
    }
    
    @objc func createTarget() {
        target = SKSpriteNode(imageNamed: "target")
        target.size = CGSize(width: 50, height: 50)
        addChild(target)
        target.position = CGPoint(x: 1200, y: 192)
        target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
        target.physicsBody?.categoryBitMask = 1
        target.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        target.physicsBody?.angularVelocity = 5
        target.physicsBody?.linearDamping = 0
        target.physicsBody?.angularDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
