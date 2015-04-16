//
//  GameScene.swift
//  VortexGame
//
//  Created by Letícia Gonçalves on 4/16/15.
//  Copyright (c) 2015 LazyFox. All rights reserved.
//


import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case Player = 1
    case Wall = 2
    case Star = 4
    case Vortex = 8
    case Finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var motionManager: CMMotionManager!
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var scoreLabel: SKLabelNode!
    var victoryLabel: SKLabelNode!
    let startGameButton = SKSpriteNode()
    let exitButton = SKSpriteNode()
    var timer = NSTimer()
    var counter:Int = 5
    var labelCounter:SKLabelNode = SKLabelNode()
    var lvl:Int = 0
    var startPosition: CGPoint?
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameOver = false
    
    override func didMoveToView(view: SKView) {
        doEverthingThatINeed()
    }
    
    func doEverthingThatINeed(){
        lvl++
        if(lvl > 3){
            removeAllChildren()
            gameOver = true
            var finalLabel: SKLabelNode = SKLabelNode()
            finalLabel = SKLabelNode(fontNamed: "Chalkduster")
            finalLabel.position = CGPoint(x: 500, y: 450)
            finalLabel.zPosition=100
            finalLabel.text="Congratulations! Your Score : \(score)"
            addChild(finalLabel)
            
        }
        else{
            var actualLvl = "level\(lvl)"
            let background = SKSpriteNode(imageNamed: "background.jpg")
            background.position = CGPoint(x: 512, y: 384)
            background.blendMode = .Replace
            addChild(background)
            
            loadLevel(lvl: actualLvl)
            createPlayer()
            
            scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.text = "Score: \(score)"
            scoreLabel.position = CGPoint(x: 100, y: 100)
            scoreLabel.zPosition=100
            addChild(scoreLabel)
            
            physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            physicsWorld.contactDelegate = self
            
            motionManager = CMMotionManager()
            motionManager.startAccelerometerUpdates()
        }
    }
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = startPosition!
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.linearDamping = 0.5
        
        player.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        player.physicsBody!.contactTestBitMask = CollisionTypes.Star.rawValue | CollisionTypes.Vortex.rawValue | CollisionTypes.Finish.rawValue
        player.physicsBody!.collisionBitMask = CollisionTypes.Wall.rawValue
        addChild(player)
    }
    
    func loadLevel(lvl level: String) {
        removeAllChildren()
        removeAllActions()
        if let levelPath = NSBundle.mainBundle().pathForResource(level, ofType: "txt") {
            if let levelString = NSString(contentsOfFile: levelPath, usedEncoding: nil, error: nil) {
                let lines = levelString.componentsSeparatedByString("\n") as! [String]
                
                for (row, line) in enumerate(reverse(lines)) {
                    for (column, letter) in enumerate(line) {
                        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                        if letter == "i"{
                            startPosition = position
                        }
                        if letter == "x" {
                            let node = SKSpriteNode(imageNamed: "block")
                            node.position = position
                            
                            node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
                            node.physicsBody!.categoryBitMask = CollisionTypes.Wall.rawValue
                            node.physicsBody!.dynamic = false
                            addChild(node)
                        } else if letter == "v"  {
                            let node = SKSpriteNode(imageNamed: "vortex")
                            node.name = "vortex"
                            node.position = position
                            node.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)))
                            node.physicsBody = SKPhysicsBody(circleOfRadius: (node.size.width-5) / 2)
                            node.physicsBody!.dynamic = false
                            
                            node.physicsBody!.categoryBitMask = CollisionTypes.Vortex.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            addChild(node)
                        } else if letter == "s"  {
                            let node = SKSpriteNode(imageNamed: "star")
                            node.name = "star"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            
                            node.physicsBody!.categoryBitMask = CollisionTypes.Star.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            node.position = position
                            addChild(node)
                        } else if letter == "f"  {
                            let node = SKSpriteNode(imageNamed: "finish")
                            node.name = "finish"
                            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                            node.physicsBody!.dynamic = false
                            
                            node.physicsBody!.categoryBitMask = CollisionTypes.Finish.rawValue
                            node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            node.physicsBody!.collisionBitMask = 0
                            node.position = position
                            addChild(node)
                        }
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if !gameOver {
            #if (arch(i386) || arch(x86_64))
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
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            playerCollidedWithNode(contact.bodyB.node!)
        } else if contact.bodyB.node == player {
            playerCollidedWithNode(contact.bodyA.node!)
        }
        
    }
    
    
    func playerCollidedWithNode(node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody!.dynamic = false
            gameOver = true
            if(score > 0){
                score -= 1
            }
            let move = SKAction.moveTo(node.position, duration: 0.25)
            let scale = SKAction.scaleTo(0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.runAction(sequence) { [unowned self] in
                self.createPlayer()
                self.gameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            ++score
        } else if node.name == "finish" {
            gameOver = true
            victoryLabel = SKLabelNode(fontNamed: "Chalkduster")
            victoryLabel.text = "Awesome!"
            victoryLabel.fontSize=40
            victoryLabel.zPosition=100
            victoryLabel.position = CGPoint(x: 500, y: 400)
            addChild(victoryLabel)
            labelCounter = SKLabelNode(fontNamed: "Chalkduster")
            labelCounter.position = CGPoint(x: 500, y: 450)
            labelCounter.zPosition=100
            addChild(labelCounter)
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0
                , target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
            
            //  addChild(exitButton)
            
            
        }
    }
    
    func updateTimer(dt:NSTimer)
    {
        counter--
        if counter==0{
            timer.invalidate()
            gameOver=false
            counter=5
            doEverthingThatINeed()
        } else{
            labelCounter.text = "Next level in \(counter) seconds"
        }
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
    
}

