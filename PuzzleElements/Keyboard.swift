//
//  Keyboard.swift
//  WWDC24
//
//  Created by Gustavo Binder on 20/02/24.
//

import SpriteKit

class Keyboard : SKSpriteNode {
    
    private let width = 820.0
    private let height = 1180.0
    
    private var writingDelegate : WritingDelegate!
    private var keys : [Key] = []
    
    private var type : picture!
    
    private var translated : SKLabelNode = SKLabelNode(text: "TRANSLATED")
    
    init(_ type: picture, _ wd: WritingDelegate)
    {
        for font in UIFont.familyNames {
            print(font)
        }
        
        let texture = SKTexture(imageNamed: "Keyboard")
        
        self.writingDelegate = wd
        self.type = type
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        self.isUserInteractionEnabled = false
        
        self.translated.zPosition = -1
        
        self.translated.fontName = "Didot"
        self.translated.fontSize = 80
        self.translated.position = CGPoint(x: 0, y: -20)
        self.translated.fontColor = .black
        
        position = CGPoint(x: width/2, y: -size.height/2)
        
        addChild(translated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func sendWord(_ word: String) {
        writingDelegate.writeWord(word)
    }
    
    public func createKeys() {
        for (n, x) in OptionContainer.options[self.type]!.enumerated() {
            addKey(
                OptionContainer.all_options[x],
                CGPoint(x: ((n % 4)*200) - 300, y: ((n/4) * 100) - 150)
            )
        }
    }
    
    private func addKey(_ text: String, _ pos: CGPoint) {
        let key = Key(text: text, kb: self)
        
        if !OptionContainer.getCurrentPhrases(type).contains(text) {
            addChild(key)
        }
        
        keys.append(key)
        
        key.position = pos
    }
    
    public func destroyAllKeys() {
        for key in keys {
            key.removeFromParent()
        }
        keys.removeAll()
    }
    
    public func addExistingKey(_ word: String) {
        for key in keys {
            if key.label.text == word {
                addChild(key)
                break
            }
        }
    }
    
    public func appear() {
        let move = SKAction.move(to: CGPoint(x: width/2, y: size.height/2), duration: 0.2)
        
        run(move)
    }
    
    public func disappear() {
        let move = SKAction.move(to: CGPoint(x: width/2, y: -size.height/2), duration: 0.5)
        
        run(move)
    }
    
    public func showTranslation() {
        self.translated.zPosition = 2
        
        let over_grow = SKAction.scale(to: 1.2, duration: 0.05)
        let shrink = SKAction.scale(to: 1, duration: 0.1)
        
        let sequence = SKAction.sequence([over_grow, shrink])
        run(sequence)
    }
}

class Key : SKSpriteNode {
    
    private var keyboard : Keyboard
    private var word : String = "No Word"
    
    public var label : SKLabelNode
    
    init(text: String, kb: Keyboard) {
        self.keyboard = kb
        self.label = SKLabelNode(text: text)
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 200, height: 80))
        
        label.fontName = "Didot"
        label.fontSize = 40
        
        label.text = text
        label.fontColor = .black
        
        self.word = text
        self.isUserInteractionEnabled = true
        
        addChild(label)
        label.position = CGPoint(x: 0, y: -10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keyboard.sendWord(word)
        removeFromParent()
    }
}
