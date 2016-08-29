//
//  GameScene.swift
//  SuperWar
//
//  Created by bamsae on 2016. 7. 11..
//  Copyright (c) 2512년 bamsae. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var plane: SKSpriteNode?
    var isMoveLeft = false
    var isMoveRight = false
    
    var gametimer: Double = 10.0
    var heart: Int = 5
    var kill: Int = 25
    
    var timeLabel: SKLabelNode?
    var levelLabel: SKLabelNode?
    
    var alien1: SKSpriteNode?
    var alien2: SKSpriteNode?
    var alien3: SKSpriteNode?
    
    var alien1Bitmask: UInt32 = 0b1
    var alien2Bitmask: UInt32 = 0b10
    var bullet1Bitmask: UInt32 = 0b100
    var bullet2Bitmask: UInt32 = 0b1000
    var planeBitmask: UInt32 = 0b10000
    var alien3Bitmask: UInt32 = 0b100000
    
    var alien1ShootTimer: Double = 0
    var alien2ShootTimer: Double = 0
    
    var ammoCount: Int = 5
    var ammoTimer: Double = 0.0
    var ammo1: SKShapeNode?
    var ammo2: SKShapeNode?
    var ammo3: SKShapeNode?
    var ammo4: SKShapeNode?
    var ammo5: SKShapeNode?
    
    var alienPointLabel: SKLabelNode?
    
    var lifeLabel: SKLabelNode?
    
    var level: Int = 0
    
    var shootTimer: Double = 0
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        if (SaveData.level == nil) {
            SaveData.level = 1
        }
        if (SaveData.point == nil) {
            SaveData.point = 0
        }
        level = SaveData.level!
        if (level > 13) {
            level = 13
        }
        
        let space = SKSpriteNode(imageNamed: "Space")
        space.anchorPoint = CGPoint(x: 0, y: 0.5)
        space.setScale(1)
        space.zPosition = -1
        space.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.scene?.addChild(space)
        let space2 = SKSpriteNode(imageNamed: "Space")
        space2.anchorPoint = CGPoint(x: 1, y: 0.5)
        space2.setScale(1)
        space2.zPosition = -1
        space2.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.scene?.addChild(space2)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel?.fontSize = 50
        timeLabel?.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        timeLabel?.text = String(format: "time: %.1lf", gametimer)
        self.scene?.addChild(timeLabel!)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel?.fontSize = 50
        levelLabel?.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2-70)
        levelLabel?.text = String(format: "level: %d!!", SaveData.level!)
        self.scene?.addChild(levelLabel!)
        
        alienPointLabel = SKLabelNode(fontNamed: "Chalkduster")
        alienPointLabel?.fontSize = 50
        alienPointLabel?.position = CGPoint(x: self.frame.size.width - 50, y: self.frame.size.height - 150)
        alienPointLabel?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        self.scene?.addChild(alienPointLabel!)
        
        lifeLabel = SKLabelNode(fontNamed: "Chalkduster")
        lifeLabel?.fontSize = 50
        lifeLabel?.position = CGPoint(x: self.frame.size.width - 50, y: self.frame.size.height - 220)
        lifeLabel?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        self.scene?.addChild(lifeLabel!)
        
        makeAlien1()
        if (level > 3 || level%2==0) {
            makeAlien2()
        }
        if (level > 6 || level%2==1) {
            makeAlien3()
        }
        makePlane()
        
        alien1ShootTimer = randomTime()
        alien2ShootTimer = randomTime()
        
        ammo1 = SKShapeNode(rectOfSize: CGSize(width: 100, height: 50))
        ammo1?.strokeColor = UIColor.blackColor()
        ammo1?.fillColor = UIColor.yellowColor()
        ammo1?.position = CGPoint(x: self.frame.size.width-200, y: 300)
        self.scene?.addChild(ammo1!)
        ammo2 = SKShapeNode(rectOfSize: CGSize(width: 100, height: 50))
        ammo2?.strokeColor = UIColor.blackColor()
        ammo2?.fillColor = UIColor.orangeColor()
        ammo2?.position = CGPoint(x: self.frame.size.width-200, y: 250)
        self.scene?.addChild(ammo2!)
        ammo3 = SKShapeNode(rectOfSize: CGSize(width: 100, height: 50))
        ammo3?.strokeColor = UIColor.blackColor()
        ammo3?.fillColor = UIColor.orangeColor()
        ammo3?.position = CGPoint(x: self.frame.size.width-200, y: 200)
        self.scene?.addChild(ammo3!)
        ammo4 = SKShapeNode(rectOfSize: CGSize(width: 100, height: 50))
        ammo4?.strokeColor = UIColor.blackColor()
        ammo4?.fillColor = UIColor.redColor()
        ammo4?.position = CGPoint(x: self.frame.size.width-200, y: 150)
        self.scene?.addChild(ammo4!)
        ammo5 = SKShapeNode(rectOfSize: CGSize(width: 100, height: 50))
        ammo5?.strokeColor = UIColor.blackColor()
        ammo5?.fillColor = UIColor.redColor()
        ammo5?.position = CGPoint(x: self.frame.size.width-200, y: 100)
        self.scene?.addChild(ammo5!)
    }
    
    
    var lastTime: Double?
    override func update(currentTime: CFTimeInterval) {
        if (lastTime == nil || currentTime - lastTime! > 1) {
            lastTime = currentTime
        }
        
        /* Called before each frame is rendered */
        var planePosition = plane!.position
        if (isMoveLeft == true) {
            planePosition.x = planePosition.x-5
            if (planePosition.x < plane!.size.width/2) {
                planePosition.x = plane!.size.width/2
            }
        }
        if (isMoveRight == true) {
            planePosition.x = planePosition.x+5
            if (planePosition.x > self.frame.size.width-plane!.size.width/2) {
                planePosition.x = self.frame.size.width-plane!.size.width/2
            }
        }
        
        plane!.position = planePosition
        
        timeLabel?.text = String(format: "time: %.1lf", gametimer)
        gametimer -= (currentTime-lastTime!)
        
        
        alien1ShootTimer -= (currentTime - lastTime!)
        alien2ShootTimer -= (currentTime - lastTime!)
        
        if (alien1ShootTimer < 0) {
            alien1Shoot()
            alien3Shoot()
            alien1ShootTimer = randomTime()
        }
        if (alien2ShootTimer < 0) {
            alien2Shoot()
            alien2ShootTimer = randomTime()
        }
        
        shootTimer -= (currentTime - lastTime!)
        if (shootTimer < 0 && ammoCount > 0) {
            let bullet = SKShapeNode(circleOfRadius: 5)
            bullet.position = CGPoint(x: plane!.position.x, y: plane!.position.y+50)
            bullet.fillColor = UIColor.blueColor()
            self.scene?.addChild(bullet)
            
            let move = SKAction.moveToY(self.frame.size.height + bullet.frame.size.height, duration: 1.2357)
            bullet.runAction(SKAction.sequence([move, SKAction.removeFromParent()]))
            
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
            bullet.physicsBody?.collisionBitMask = 0
            bullet.physicsBody?.categoryBitMask = bullet1Bitmask
            bullet.physicsBody?.contactTestBitMask = alien1Bitmask|alien2Bitmask|alien3Bitmask
            bullet.physicsBody?.dynamic = true
            
            ammoCount -= 1
            shootTimer = 0.5
        }
        
        lastTime = currentTime
        
        updateAmmo()
        
        alienPointLabel?.text = String(format: "point: %d", SaveData.point!)
        lifeLabel?.text = String(format: "life: %d", heart)
        
        if heart <= 0 || gametimer <= 0 {
            let isWin = (heart > 0)
            let flip = SKTransition.flipVerticalWithDuration(0.5)
            let overScene = GameOverScene(size: self.frame.size, isWin:isWin, point: SaveData.point!)
            self.view?.presentScene(overScene, transition: flip)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        
        let touchLocation = touch!.locationInNode(self)
        
        if(plane!.containsPoint(touchLocation))
        {
            ammoCount = 5
        } else if touchLocation.x > self.frame.size.width/2 {
            isMoveRight = true
        } else if touchLocation.x < self.frame.size.width/2 {
            isMoveLeft = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        
        let touchLocation = touch!.locationInNode(self)
        
        if touchLocation.x > self.frame.size.width/2 {
            isMoveRight = false
        } else if touchLocation.x < self.frame.size.width/2 {
            isMoveLeft = false
        }
    }
    
    func updateAmmo() {
        ammo1?.hidden = (ammoCount < 5)
        ammo2?.hidden = (ammoCount < 4)
        ammo3?.hidden = (ammoCount < 3)
        ammo4?.hidden = (ammoCount < 2)
        ammo5?.hidden = (ammoCount < 1)
    }
    
    func randomX() -> Int {
        return Int(arc4random())%Int(self.frame.size.width)
    }
    
    func randomTime() -> Double {
        let  levelPoint = Double(0.03*Double(self.level))
        return Double(Float(arc4random()) / Float(UINT32_MAX))*0.5+1.3-levelPoint
    }
    
    func alien1Shoot() {
        
        let bullet2 = SKShapeNode(circleOfRadius: 5)
        bullet2.position = CGPoint(x: alien1!.position.x, y: alien1!.position.y+50)
        bullet2.fillColor = UIColor.redColor()
        self.scene?.addChild(bullet2)
        
        let move2 = SKAction.moveToY(-bullet2.frame.size.height, duration: 1.2357)
        bullet2.runAction(SKAction.sequence([move2, SKAction.removeFromParent()]))
        
        bullet2.physicsBody = SKPhysicsBody(rectangleOfSize: bullet2.frame.size)
        bullet2.physicsBody?.collisionBitMask = 0
        bullet2.physicsBody?.categoryBitMask = bullet2Bitmask
        bullet2.physicsBody?.contactTestBitMask = planeBitmask
        bullet2.physicsBody?.dynamic = true
        
    }
    func alien2Shoot() {
        if (alien2 == nil) { return }
        
        let bullet3 = SKShapeNode(circleOfRadius: 5)
        bullet3.position = CGPoint(x: alien2!.position.x, y: alien2!.position.y+50)
        bullet3.fillColor = UIColor.redColor()
        self.scene?.addChild(bullet3)
        
        let move3 = SKAction.moveTo(CGPoint(x: CGFloat(randomX()), y: -bullet3.frame.size.height), duration: 1.2357)
        bullet3.runAction(SKAction.sequence([move3, SKAction.removeFromParent()]))
        
        bullet3.physicsBody = SKPhysicsBody(rectangleOfSize: bullet3.frame.size)
        bullet3.physicsBody?.collisionBitMask = 0
        bullet3.physicsBody?.categoryBitMask = bullet2Bitmask
        bullet3.physicsBody?.contactTestBitMask = planeBitmask
        bullet3.physicsBody?.dynamic = true
        
    }
    func alien3Shoot() {
        if (alien3 == nil) { return }
        
        let bullet3 = SKShapeNode(circleOfRadius: 5)
        bullet3.position = CGPoint(x: alien3!.position.x, y: alien3!.position.y+50)
        bullet3.fillColor = UIColor.redColor()
        self.scene?.addChild(bullet3)
        
        let move3 = SKAction.moveTo(CGPoint(x: CGFloat(randomX()), y: -bullet3.frame.size.height), duration: 1.2357)
        bullet3.runAction(SKAction.sequence([move3, SKAction.removeFromParent()]))
        
        bullet3.physicsBody = SKPhysicsBody(rectangleOfSize: bullet3.frame.size)
        bullet3.physicsBody?.collisionBitMask = 0
        bullet3.physicsBody?.categoryBitMask = bullet2Bitmask
        bullet3.physicsBody?.contactTestBitMask = planeBitmask
        bullet3.physicsBody?.dynamic = true
    }
    
    func makePlane() {
        plane = SKSpriteNode(imageNamed: "Spaceship")
        plane!.setScale(0.7)
        plane!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        plane!.position = CGPoint(x: self.frame.size.width * 0.5, y: plane!.size.height/2)
        self.scene?.addChild(plane!)
        
        plane!.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: plane!.size.width-20, height: plane!.size.height-10))
        plane!.physicsBody?.collisionBitMask = 0
        plane!.physicsBody?.categoryBitMask = planeBitmask
        plane!.physicsBody?.contactTestBitMask = bullet2Bitmask
        plane!.physicsBody?.dynamic = true
        
        ammoCount = 5
    }
    
    func makeAlien1() {
        let alien = SKSpriteNode(imageNamed: "Monster")
        alien.setScale(0.7)
        alien.position = CGPoint(x: alien.size.width/2, y: self.frame.size.height-alien.size.height/2)
        self.scene?.addChild(alien)
        
        let moveAction = SKAction.moveTo(CGPoint(x: self.frame.size.width, y:alien.position.y), duration: 4)
        let resetAction = SKAction.moveToX(0, duration: 0)
        
        let move = SKAction.repeatActionForever(SKAction.sequence([moveAction, resetAction]))
        alien.runAction(move)
        
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: alien.size.width-20, height: alien.size.height-10))
        alien.physicsBody?.collisionBitMask = 0
        alien.physicsBody?.categoryBitMask = alien1Bitmask
        alien.physicsBody?.contactTestBitMask = bullet1Bitmask
        alien.physicsBody?.dynamic = false
        
        alien1 = alien
    }
    
    func makeAlien2() {
        let alien = SKSpriteNode(imageNamed: "Monster")
        alien.setScale(0.7)
        alien.position = CGPoint(x: self.size.width, y: self.frame.size.height-alien.size.height-alien.size.height/2)
        self.scene?.addChild(alien)
        
        let moveAction2 = SKAction.moveToX(0, duration: 4)
        let resetAction2 = SKAction.moveToX(self.size.width, duration: 0)
        
        let move2 = SKAction.repeatActionForever(SKAction.sequence([moveAction2, resetAction2]))
        alien.runAction(move2)
        
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: alien.size.width-20, height: alien.size.height-10))
        alien.physicsBody?.collisionBitMask = 0
        alien.physicsBody?.categoryBitMask = alien2Bitmask
        alien.physicsBody?.contactTestBitMask = bullet1Bitmask
        alien.physicsBody?.dynamic = false
        
        alien2 = alien
    }
    func makeAlien3() {
        let alien = SKSpriteNode(imageNamed: "Monster")
        alien.setScale(0.7)
        alien.position = CGPoint(x: 0, y: self.frame.size.height-alien.size.height*2-alien.size.height/2)
        self.scene?.addChild(alien)
        
        let moveAction2 = SKAction.moveToX(self.size.width, duration: 4)
        let resetAction2 = SKAction.moveToX(0, duration: 0)
        
        let move2 = SKAction.repeatActionForever(SKAction.sequence([moveAction2, resetAction2]))
        alien.runAction(move2)
        
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: alien.size.width-20, height: alien.size.height-10))
        alien.physicsBody?.collisionBitMask = 0
        alien.physicsBody?.categoryBitMask = alien3Bitmask
        alien.physicsBody?.contactTestBitMask = bullet1Bitmask
        alien.physicsBody?.dynamic = false
        
        alien3 = alien
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == bullet1Bitmask) {
            let alien = bodyB.node
            let bullet = contact.bodyA.node
            
            alien?.runAction(SKAction.fadeOutWithDuration(0.4))
            bullet?.runAction(SKAction.fadeOutWithDuration(0.1))
            
            if (bodyB.categoryBitMask == alien1Bitmask) {
                makeAlien1()
            } else if (bodyB.categoryBitMask == alien2Bitmask) {
                makeAlien2()
            } else if (bodyB.categoryBitMask == alien3Bitmask) {
                makeAlien3()
            }
            
            alien?.physicsBody?.categoryBitMask = 0
            bullet?.physicsBody?.categoryBitMask = 0
            alien?.physicsBody = nil
            bullet?.physicsBody = nil
            
            SaveData.point! += level
        } else if (bodyB.categoryBitMask == bullet1Bitmask) {
            let alien = bodyA.node
            let bullet = contact.bodyB.node
            
            alien?.runAction(SKAction.fadeOutWithDuration(0.4))
            bullet?.runAction(SKAction.fadeOutWithDuration(0.1))
            
            if (bodyA.categoryBitMask == alien1Bitmask) {
                makeAlien1()
            } else if (bodyA.categoryBitMask == alien2Bitmask) {
                makeAlien2()
            } else if (bodyA.categoryBitMask == alien3Bitmask) {
                makeAlien3()
            }
            
            alien?.physicsBody?.categoryBitMask = 0
            bullet?.physicsBody?.categoryBitMask = 0
            alien?.physicsBody = nil
            bullet?.physicsBody = nil
            
            SaveData.point! += level
        }
        
        
        if (bodyA.categoryBitMask == bullet2Bitmask) {
            let plane = bodyB.node
            let bullet = contact.bodyA.node
            
            plane?.runAction(SKAction.fadeOutWithDuration(0.4))
            bullet?.runAction(SKAction.fadeOutWithDuration(0.1))
            
            plane?.physicsBody?.categoryBitMask = 0
            bullet?.physicsBody?.categoryBitMask = 0
            plane?.physicsBody = nil
            bullet?.physicsBody = nil
            
            makePlane()
            heart -= 1
        } else if (bodyB.categoryBitMask == bullet2Bitmask) {
            let plane = bodyA.node
            let bullet = contact.bodyB.node
            
            plane?.runAction(SKAction.fadeOutWithDuration(0.4))
            bullet?.runAction(SKAction.fadeOutWithDuration(0.1))
            
            plane?.physicsBody?.categoryBitMask = 0
            bullet?.physicsBody?.categoryBitMask = 0
            plane?.physicsBody = nil
            bullet?.physicsBody = nil
            
            makePlane()
            heart -= 1
        }
        
    }
}
