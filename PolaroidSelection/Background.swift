//
//  GameScene.swift
//  WWDC24
//
//  Created by Gustavo Binder on 19/02/24.
//

import SpriteKit

class Background: SKScene {
    
    var rainManager : RainManager!
    var piles : [Pile] = []
    var flash : SKSpriteNode!
    
    override init()
    {
        let width = 820.0
        let height = 1180.0
        
        flash = SKSpriteNode(texture: nil, color: .white, size: CGSize(width: width, height: height))
        flash.alpha = 0
        flash.zPosition = 20
        
        super.init(size: CGSize(width: width, height: height))
        
        flash.position = CGPoint(x: width/2, y: height/2)
        
        addChild(flash)
        
        self.scaleMode = .aspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        rainManager = RainManager(self)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = doubleSize(background.size)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -15
        
        rainManager.init_piles()
        
        let clouds = SKAction.run {
            self.init_clouds()
        }
        let wait = SKAction.wait(forDuration: 3)
        let pola = SKAction.run {
            self.rainManager.spawn_polaroids()
            self.rainManager.spawn_polaroids()
        }        
        let sequence = SKAction.sequence([clouds, wait, pola])
        
        run(sequence)
        addChild(background)
    }
    
    func init_clouds()
    {
        let clouds = SKSpriteNode(imageNamed: "Clouds")
        clouds.position = CGPoint(x: frame.midX, y: frame.maxY + clouds.size.height / 2)
        
        let move_down = SKAction.move(by: CGVector(dx: 0, dy: -(clouds.size.height/2)), duration: 4)
        let tiny_up = SKAction.move(by: CGVector(dx: 0, dy: 30), duration: 2)
        
        let move_1 = SKAction.move(by: CGVector(dx: -10, dy: -20), duration: 2)
        let move_2 = SKAction.move(by: CGVector(dx: 20, dy: 0), duration: 2)
        let move_3 = SKAction.move(by: CGVector(dx: -10, dy: 20), duration: 2)
        let repeat_movement = SKAction.repeatForever(SKAction.sequence([move_1, move_2, move_3]))
        
        clouds.run(SKAction.sequence([move_down, tiny_up, repeat_movement]))
        
        addChild(clouds)
    }
    
    public func flashAction() {
        let appear = SKAction.fadeIn(withDuration: 0.02)
        let disappear = SKAction.fadeOut(withDuration: 0.2)
        let wait = SKAction.wait(forDuration: 0.02)
        let sequence = SKAction.sequence([appear, wait, disappear])
        
        flash.run(sequence)
        print("Porra")
    }
}
