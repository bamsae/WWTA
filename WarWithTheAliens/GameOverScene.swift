//
//  GameOverScene.swift
//  SuperWar
//
//  Created by bamsae on 2016. 8. 3..
//  Copyright © 2016년 bamsae. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var isWin: Bool
    var point: Int
    
    init(size: CGSize, isWin: Bool, point: Int) {
        self.isWin = isWin
        self.point = point
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.fontSize = 50
        gameOverLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2+70)
        if self.isWin == true {
            gameOverLabel.text = "GAME CLEAR!!"
            SaveData.level! += 1
        } else {
            gameOverLabel.text = "GAME OVER.."
        }
        
        let levelLabel = SKLabelNode(fontNamed: "Jazzlet")
        levelLabel.fontSize = 40
        levelLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        levelLabel.text = String(format:"level: %d", SaveData.level!)
        
        let pointLabel = SKLabelNode(fontNamed: "Jazzlet")
        pointLabel.fontSize = 40
        pointLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2-70)
        pointLabel.text = String(format: "point: %d", self.point)
        
        self.scene?.addChild(gameOverLabel)
        self.scene?.addChild(levelLabel)
        self.scene?.addChild(pointLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let flip = SKTransition.flipVerticalWithDuration(0.5)
        let gameScene = GameScene(size: self.frame.size)
        self.view?.presentScene(gameScene, transition: flip)
        
    }
}
