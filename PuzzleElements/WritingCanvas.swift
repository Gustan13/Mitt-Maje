//
//  WritingCanvas.swift
//  WWDC24
//
//  Created by Gustavo Binder on 20/02/24.
//

import SpriteKit

var translated_phrases : [picture : String] = [
    .HELLO : "hello! I am Gustavo",
    .GAMES : "I am playing games",
    .THANKS : "thank you",
    .GIVE : "I am giving you the banana",
    .BANANA : "thank you for the banana",
    .EAT : "I am eating the banana",
    .MITTMAJE : "thank you so much for playing my game"
]

class Word : SKLabelNode {
    
    private var writingCanvas : WritingCanvas
    public var wordWidth : CGFloat = 0
    
    init(_ word: String, _ wc: WritingCanvas) {
        self.writingCanvas = wc
        
        super.init()
        
        self.fontName = "Didot"
        
        self.text = word
        
        self.fontSize = 40
        
        wordWidth = self.frame.width
        
        self.alpha = 0
        
        self.isUserInteractionEnabled = true
        self.fontColor = .black
        
        self.fade(to: 1, duration: wordWidth/200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isUserInteractionEnabled = false
        
        let wait = SKAction.wait(forDuration: wordWidth/100)
        let runAppear = SKAction.run { self.fade(to: 0, duration: self.wordWidth/200) }
        let erase = SKAction.run {
            self.writingCanvas.removeWord(self)
            self.writingCanvas.writingAnimation(
                self, self.writingCanvas.eraser, self.wordWidth/CGFloat(self.text!.count), self.text!.count) }
        let removeWord = SKAction.run { self.removeFromParent() }
        let sequence = SKAction.sequence([runAppear, erase, wait, removeWord])
        
        run(sequence)
    }
    
    func fade(to: Int, duration: CGFloat) {
        let alpha = SKAction.fadeAlpha(to: CGFloat(to), duration: duration)
        
        run(alpha)
    }
}

class WritingCanvas : SKSpriteNode {
    
    private let width = 820.0
    private let height = 1180.0
    
    private var textLabel : SKLabelNode!
    
    private var writingDelegate : WritingDelegate
    private var phrase : [Word] = []
    
    public var eraser : SKSpriteNode
    public var pencil : SKSpriteNode
    
    private var cancelPencil = false
    
    init(_ picture_at_display: picture, _ wd: WritingDelegate) {
        let texture = SKTexture(imageNamed: "Canvas")
        
        self.writingDelegate = wd
        
        self.textLabel = SKLabelNode(text: translated_phrases[picture_at_display])
        
        self.eraser = SKSpriteNode(imageNamed: "Eraser")
        self.pencil = SKSpriteNode(imageNamed: "Pencil")
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        self.textLabel.fontSize = 40
        self.textLabel.fontName = "Didot"
        self.textLabel.fontColor = .black
        self.textLabel.zPosition = -3
        self.textLabel.lineBreakMode = .byClipping
        self.textLabel.numberOfLines = 2
        
        self.eraser.zPosition = 10
        self.pencil.zPosition = 10
        self.pencil.anchorPoint = CGPoint(x: 0, y: -0)
        self.eraser.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.eraser.alpha = 0
        self.pencil.alpha = 0
        
        self.addChild(eraser)
        self.addChild(pencil)
        
        self.isUserInteractionEnabled = false
        
        self.zPosition = -1
        
        addChild(self.textLabel)
        
        self.position = CGPoint(x: width/2, y: -size.height/2)
        
        let current_phrase = OptionContainer.getCurrentPhrases(picture_at_display)
        if !current_phrase.isEmpty {
            cancelPencil = true
        }
        
        for word in current_phrase {
            writeWord(word)
        }
        
        cancelPencil = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func writeWord(_ word: String) {
        let wordLabel = Word(word, self)
        
        addChild(wordLabel)
        
        setWordPosition(wordLabel)
        
        if !cancelPencil {
            self.writingAnimation(wordLabel, self.pencil, wordLabel.wordWidth/CGFloat(wordLabel.text!.count), wordLabel.text!.count)
        }
        
        phrase.append(wordLabel)
    }
    
    public func removeWord(_ word: Word) {
        
        let wait = SKAction.wait(forDuration: word.wordWidth/120)
        
        let action = SKAction.run {
            self.phrase.removeAll { w in
                if w == word {
                    return true
                }
                return false
            }
            self.reorderWords()
            self.writingDelegate.eraseWord(word.text!)
        }
        
        run(SKAction.sequence([wait,action]))
    }
    
    private func reorderWords() {
        if phrase.isEmpty {
            return
        }
        
        var newX = CGFloat(phrase.first!.wordWidth/2.0 - width/2)
        var newY = 40.0
        
        var previousLabel : Word = phrase.first!
        
        for wordLabel in phrase {
            
            if wordLabel == phrase.first {
                phrase.first?.position = CGPoint(x: newX + 25, y: newY)
                continue
            }
            
            let lastX = previousLabel.position.x
            let lastY = previousLabel.position.y
            let lastWidth = previousLabel.wordWidth
            
            newX = lastX + lastWidth/2 + wordLabel.wordWidth/2
            newY = lastY
            
            if (lastX + wordLabel.wordWidth * 2) > (width/2) {
                newX = wordLabel.wordWidth/2 - width/2
                newY += -50
            }
            
            wordLabel.position = CGPoint(x: newX + 25, y: newY)
            
            previousLabel = wordLabel
        }
    }
    
    private func setWordPosition(_ wordLabel: Word) {
        var newX : CGFloat = wordLabel.wordWidth/2 - width/2
        var newY : CGFloat = 40.0
        
        if !phrase.isEmpty {
            let lastX = phrase.last!.position.x
            let lastY = phrase.last!.position.y
            let lastWidth = phrase.last!.wordWidth
            
            newX = lastX + lastWidth/2 + wordLabel.wordWidth/2
            newY = lastY
            
            if (lastX + wordLabel.wordWidth * 2) > (width/2) {
                newX = wordLabel.wordWidth/2 - width/2
                newY += -50
            }
        }
        
        wordLabel.position = CGPoint(x: newX + 25, y: newY)
    }
    
    public func appear() {
        let move = SKAction.move(to: CGPoint(x: width/2, y: height/2 - 85), duration: 0.3)
        
        run(move)
    }
    
    public func disappear() {
        let move = SKAction.move(to: CGPoint(x: width/2, y: -size.height/2), duration: 0.5)
        
        run(move)
    }
    
    public func getPhraseString() -> [String] {
        var words : [String] = []
        
        for word in phrase {
            words.append(word.text!)
        }
        
        return words
    }
    
    public func getPhraseWords() -> [Word] {
        return phrase
    }
    
    public func showTranslation() {
        for word in phrase {
            word.fontColor = .blue
        }
    }
    
    public func writingAnimation(_ destiny_object: Word, _ object: SKSpriteNode, _ amount: Double, _ wordWidth : Int) {
        object.run(SKAction.stop())
        
        var position = CGPoint(x: destiny_object.position.x - destiny_object.wordWidth/2, y: destiny_object.position.y)
        object.position = position
        
        let wait = SKAction.wait(forDuration: 0.025)
        let appear = SKAction.fadeIn(withDuration: 0.1)
        let go_up = SKAction.move(by: CGVector(dx: amount/2, dy: 15), duration: 0.025)
        let go_down = SKAction.move(by: CGVector(dx: amount/2, dy: -15), duration: 0.025)
        let disappear = SKAction.fadeOut(withDuration: 0.1)
        
        let amount_of_jiggle : [SKAction] = {
            var up_down_amount : [SKAction] = []
            
            for i in 1..<Int(wordWidth * 2) {
                i % 2 == 1 ? (up_down_amount.append(go_up)) : (up_down_amount.append(go_down))
                up_down_amount.append(wait)
            }
            
            return up_down_amount
        }()
        
        let sequence = SKAction.sequence([appear, SKAction.sequence(amount_of_jiggle),
                                          disappear])
        
        object.run(sequence)
    }
}
