//
//  GameScene.swift
//  AngryBirdClone
//
//  Created by Matteo Buompastore on 04/05/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var box0 = SKSpriteNode()
    var box1 = SKSpriteNode()
    var box2 = SKSpriteNode()
    var box3 = SKSpriteNode()
    var box4 = SKSpriteNode()
    var box5 = SKSpriteNode()
    var box6 = SKSpriteNode()
    var box7 = SKSpriteNode()
    var box8 = SKSpriteNode()
    var box9 = SKSpriteNode()
    
    var boxes = [SKSpriteNode]()
    
    var gameStarted = false
    
    var originalBirdPosition : CGPoint?
    
    enum ColliderTypes : UInt32 {
        case Bird = 1
        case Box = 2
        case Ground = 4
        case Tree = 8
    }
    
    override func didMove(to view: SKView) {
        /*let texture = SKTexture(imageNamed: "bird")
        bird2 = SKSpriteNode(texture: texture)
        bird2.position = CGPoint(x: 0, y: 0)
        bird2.size = CGSize(width: 90, height: 90)
        bird2.zPosition = 1
        self.addChild(bird2)*/
        
        //Physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.scene?.scaleMode = .aspectFit
        //self.physicsWorld.contactDelegate = self
        
        initBird()
        
        initBoxes()
    }
    
    func initBoxes() {
        let boxTexture = SKTexture(imageNamed: "box")
        let size = CGSize(width: boxTexture.size().width, height: boxTexture.size().height)
        boxes = [box0, box1, box2, box3, box4, box5, box6, box7, box8, box9]
        
        for i in 0..<boxes.count {
            boxes[i] = childNode(withName: "box\(i)") as! SKSpriteNode
            boxes[i].physicsBody = SKPhysicsBody(rectangleOf: size)
            boxes[i].physicsBody?.affectedByGravity = true
            boxes[i].physicsBody?.allowsRotation = true
            boxes[i].physicsBody?.isDynamic = true
            boxes[i].physicsBody?.mass = 0.1
            
            //Collision
            /*boxes[i].physicsBody?.contactTestBitMask = ColliderTypes.Box.rawValue
            boxes[i].physicsBody?.categoryBitMask = ColliderTypes.Box.rawValue
            boxes[i].physicsBody?.collisionBitMask = ColliderTypes.Box.rawValue*/
        }
    }
    
    func initBird() {
        
        bird = childNode(withName: "bird") as! SKSpriteNode
        let birdTexture = SKTexture(imageNamed: "bird")
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().width / 20)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.mass = 0.1
        originalBirdPosition = bird.position
        
        //Collision
        /*bird.physicsBody?.contactTestBitMask = ColliderTypes.Bird.rawValue
        bird.physicsBody?.categoryBitMask = ColliderTypes.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderTypes.Bird.rawValue*/
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //bird.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 200))
        moveBird(touches: touches, with: event)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveBird(touches: touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        throwBird(touches: touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if !gameStarted {
            return
        }
        // Called before each frame is rendered
        if let birdPhysicsBody = bird.physicsBody {
            if birdPhysicsBody.velocity.dx <= 0.1 && birdPhysicsBody.velocity.dy <= 0.1 && birdPhysicsBody.angularVelocity <= 0.1 {
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 1
                bird.position = originalBirdPosition!
                initBoxes()
                gameStarted = false
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {

    }
    
    func moveBird(touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if !touchNodes.isEmpty {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    func throwBird(touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                if !touchNodes.isEmpty {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                let dx = touchLocation.x - originalBirdPosition!.x
                                let dy = touchLocation.y - originalBirdPosition!.y
                                let impulse = CGVector(dx: -dx, dy: -dy)
                                bird.physicsBody?.applyImpulse(impulse)
                                bird.physicsBody?.affectedByGravity = true
                                gameStarted = true
                            }
                        }
                    }
                }
            }
        }
    }
    
}
