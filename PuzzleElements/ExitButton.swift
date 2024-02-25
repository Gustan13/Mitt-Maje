//
//  File.swift
//  
//
//  Created by Gustavo Binder on 21/02/24.
//

import SpriteKit

class ExitButton : SKSpriteNode {
    
    private var returnDelegate : ReturnDelegate
    
    private let width = 820.0
    private let height = 1180.0
    
    private var can_be_touched = true
    
    init(_ rd: ReturnDelegate) {
        let texture = SKTexture(imageNamed: "Return")
        
        returnDelegate = rd
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        self.anchorPoint = CGPoint(x: 0, y: 0.5)
        position = CGPoint(x: 0, y: height - size.height/2)
        self.setScale(0)
        zPosition = 20
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if can_be_touched {
            returnDelegate.returnToSelection()
            can_be_touched = false
        }
    }
    
    public func pop_up() {
        let grow = SKAction.scale(to: 1.2, duration: 0.04)
        let wait = SKAction.wait(forDuration: 0.04)
        let shrink = SKAction.scale(to: 1, duration: 0.05)
        
        let sequence = SKAction.sequence([grow, wait, shrink])
        
        run(sequence)
    }
    
    public func shrink_down() {
        let grow = SKAction.scale(to: 1.2, duration: 0.02)
        let wait = SKAction.wait(forDuration: 0.02)
        let shrink = SKAction.scale(to: 0, duration: 0.05)
        
        let sequence = SKAction.sequence([grow, wait, shrink])
        
        run(sequence)
    }
}
