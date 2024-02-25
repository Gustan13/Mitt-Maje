//
//  Board.swift
//  WWDC24
//
//  Created by Gustavo Binder on 20/02/24.
//

import SpriteKit

class Board : SKSpriteNode {
    
    private var polaroidSprites : [SKSpriteNode] = []
    private var phraseLabel : SKLabelNode!
    
    private let width = 820.0
    private let height = 1180.0

    
    init(_ type: picture, _ amount: Int) {
        let boardTexture : SKTexture = SKTexture(imageNamed: "Board")
        
        for p in 0...amount-1 {
            var name = type.rawValue
            if amount > 1 {
                name.append("\(p+1)")
                print(name)
            }
            
            polaroidSprites.append(SKSpriteNode(imageNamed: name))
            polaroidSprites[p].zPosition = 1
            phraseLabel = SKLabelNode(text: phrases[type]!)
            phraseLabel.fontName = "Didot"
            phraseLabel.fontSize = 45
            phraseLabel.lineBreakMode = .byClipping
            phraseLabel.numberOfLines = 2
            
        }
        
        super.init(texture: boardTexture, color: .white, size: boardTexture.size())
        
        phraseLabel.preferredMaxLayoutWidth = 0.75 * frame.width
        
        position = CGPoint(x: width/2, y: height + size.height/2)
        
        for p in 0..<amount {
            addChild(polaroidSprites[p])
            polaroidSprites[p].position = CGPoint(x: CGFloat(160 * (amount - (p + 1 + (1 - amount % 2)) + ( 1 - amount % 2) * 80)), y: polaroidSprites[p].size.height * 0.3)
        }
        addChild(phraseLabel)
        
        phraseLabel.position = CGPoint(x: 0, y: -frame.height/2 + 65)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drop_down() {
        let destination = CGPoint(x: width/2, y: height - size.height/2 - 20)
        let move = SKAction.run {
            self.move_to(destination)
        }
        let wait = SKAction.wait(forDuration: 0.24)
        let wiggle = SKAction.run {
            self.shake()
        }
        let sequence = SKAction.sequence([move, wait, wiggle])
        
        run(sequence)
    }
    
    public func rise_up() {
        let destination = CGPoint(x: width/2, y: height + size.height/2)
        move_to(destination)
    }
    
    private func move_to(_ destination: CGPoint) {
        let dropAction = SKAction.move(to: destination, duration: 0.25)
        
        run(dropAction)
    }
    
    private func shake() {
        let left = SKAction.rotate(byAngle: -0.02, duration: 0.02)
        let right = SKAction.rotate(byAngle: 0.02, duration: 0.02)
        let sequence = SKAction.sequence([left,right,right,left,left,right])
        
        run(sequence)
    }
}
