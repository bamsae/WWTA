//
//  GameOverScene.swift
//  SuperWar
//
//  Created by bamsae on 2016. 8. 3..
//  Copyright © 2016년 bamsae. All rights reserved.
//

import SpriteKit

class GameStartScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        let gameStartLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameStartLabel.fontSize = 50
        gameStartLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height-150)
        gameStartLabel.text = "War with the Aliens"
        
//        let planeSpriteNode = SKSpriteNode(imageNamed: "Spaceship")
        
        self.scene?.addChild(gameStartLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let flip = SKTransition.flipVerticalWithDuration(0.5)
        let gameScene = GameScene(size: self.frame.size)
        self.view?.presentScene(gameScene, transition: flip)
        
    }
}
