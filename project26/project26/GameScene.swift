//
//  GameScene.swift
//  project26
//
//  Created by Антон Баскаков on 12.10.2024.
//

import CoreMotion
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    let initialPlayerPosition = CGPoint(x: 96, y: 672)
    
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager!
    
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    
    var isGameOver = false
    
    var levelNumber = 1  {
        didSet {
            levelLabel.text = "Level: \(levelNumber)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    enum CollisionTypes: UInt32 {
        case player = 1
        case wall = 2
        case star = 4
        case vortex = 8
        // Challenge 3: Add a new block type, such as a teleport that moves the player from one teleport point to the other. Add a new letter type in loadLevel(), add another collision type to our enum, then see what you can do.
        case teleport = 16
        case finish = 32
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        background.name = "background"
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.name = "scoreLabel"
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.name = "levelLabel"
        levelLabel.text = "Level: 1"
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.position = CGPoint(x: 16, y: 724)
        levelLabel.zPosition = 2
        addChild(levelLabel)
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = .zero
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        loadLevel(levelNumber)
        createPlayer(at: initialPlayerPosition)
    }
    
    // Challenge 1: Rewrite the loadLevel() method so that it's made up of multiple smaller methods. This will make your code easier to read and easier to maintain, or at least it should do if you do a good job!
    func loadLevel(_ number: Int) {
        guard let levelURL = Bundle.main.url(forResource: "level\(number)", withExtension: "txt") else {
            fatalError("Couldn't find level in the app bundle.")
        }
        
        guard let levelString = try? String(contentsOf: levelURL, encoding: .utf8) else {
            fatalError("Couldn't load level from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: .newlines)
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    // load wall
                    loadWall(at: position)
                } else if letter == "v" {
                    // load vortex
                    loadVortex(at: position)
                } else if letter == "s" {
                    // load star
                    loadStar(at: position)
                } else if letter == "i" {
                    // Challenge 3: Add a new block type, such as a teleport that moves the player from one teleport point to the other. Add a new letter type in loadLevel(), add another collision type to our enum, then see what you can do.
                    // load initial teleport
                    loadInitialTeleport(at: position)
                } else if letter == "t" {
                    // Also challenge 3
                    // load teleport
                    loadTeleport(at: position)
                } else if letter == "f" {
                    // load finish
                    loadFinish(at: position)
                } else if letter == " " {
                    // this is an empty space - do nothing!
                } else {
                    fatalError("Unknown character \(letter) in level at row \(row), column \(column).")
                }
            }
        }
    }
    
    // Method to load wall
    func loadWall(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    // Method to load vortex
    func loadVortex(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    // Method to load star
    func loadStar(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    // Method to load initial teleport
    func loadInitialTeleport(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleportFrom")
        node.size = CGSize(width: 32, height: 32)
        node.name = "teleportFrom"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    // Method to load teleport
    func loadTeleport(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleportTo")
        node.size = CGSize(width: 32, height: 32)
        // Anchor point to create the player in the center of the teleport after the teleportation
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.name = "teleportTo"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    // Method to load finish
    func loadFinish(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func createPlayer(at position: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.teleport.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
#if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
#else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
#endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position , duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer(at: self?.initialPlayerPosition ?? CGPoint(x: 0, y: 0))
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "teleportFrom" {
            // Challenge 3: Add a new block type, such as a teleport that moves the player from one teleport point to the other. Add a new letter type in loadLevel(), add another collision type to our enum, then see what you can do.
            for child in self.children {
                if child.name == "teleportTo" {
                    let move = SKAction.move(to: node.position , duration: 0.25)
                    let scale = SKAction.scale(to: 0.0001, duration: 0.25)
                    let remove = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([move, scale, remove])
                    
                    player.run(sequence) { [weak self] in
                        self?.createPlayer(at: child.position)
                    }
                    
                }
            }
            
        } else if node.name == "finish" {
            // next level! Challenge 2: When the player finally makes it to the finish marker, nothing happens. What should happen? Well, that's down to you now. You could easily design several new levels and have them progress through.
            for child in self.children {
                if child.name != "background" && child.name != "scoreLabel" && child.name != "levelLabel" {
                    child.removeFromParent()
                }
            }
            levelNumber += 1
            loadLevel(levelNumber)
            createPlayer(at: initialPlayerPosition)
        }
    }
}
