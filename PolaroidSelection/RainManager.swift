//
//  RainNode.swift
//  WWDC24
//
//  Created by Gustavo Binder on 19/02/24.
//

import SpriteKit

class RainManager {
    
    private var gameManager : Background!
    private var piles : [Pile] = []
    
    init(_ gameManager: Background) {
        self.gameManager = gameManager
    }
    
    public func init_piles()
    {
        let pile_1 = Pile(sprite: "Pile_1", pile_const: 5, x: Int(gameManager.frame.maxX - 180), game: gameManager)
        let pile_2 = Pile(sprite: "Pile_2", pile_const: 7, x: Int(gameManager.frame.minX + 150), game: gameManager)
        let pile_3 = Pile(sprite: "Pile_3", pile_const: 3, x: Int(gameManager.frame.midX + 30), game: gameManager)
            
        piles.append(pile_1)
        piles.append(pile_2)
        piles.append(pile_3)
        
        for i in 0...2 {
            gameManager.addChild(piles[i].sprite)
        }
    }
    
    public func spawn_polaroids()
    {
        let spawn = SKAction.run {
            let polaroid = SKSpriteNode(imageNamed: "Polaroid")
            polaroid.position = CGPoint(x: Int.random(in: 0...Int(self.gameManager.frame.maxX - polaroid.size.height)), y: 1180)
            polaroid.setScale(CGFloat.random(in: 0.5...1.5))
            polaroid.zPosition = -1 * (1/polaroid.xScale)
            polaroid.alpha = CGFloat(polaroid.xScale / 2)
            var random_dir = Int.random(in: 0...1)
            random_dir == 0 ? (random_dir = -1) : (random_dir = 1)
            
            let falldown = SKAction.move(by: CGVector(dx: 0, dy: -3), duration: 0.01)
            let rotate = SKAction.rotate(byAngle: CGFloat(0.02 * Double(random_dir)), duration: 0.01)
            let check_if_gone = SKAction.run {
                if polaroid.position.y < -polaroid.size.height {
                    polaroid.removeFromParent()
                    for i in 0...2 {
                        self.piles[i].grow_up()
                    }
                }
            }
            
            let sequence = SKAction.sequence([falldown, rotate, check_if_gone])
            
            polaroid.run(SKAction.repeatForever(sequence))
            
            self.gameManager.addChild(polaroid)
        }
        
        let timer = SKAction.wait(forDuration: 0.3)
        
        let sequence = SKAction.sequence([timer, spawn])
        
        gameManager.run(SKAction.repeatForever(sequence))
    }
}
