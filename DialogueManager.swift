//
//  DialogueManager.swift
//  WWDC24
//
//  Created by Gustavo Binder on 24/02/24.
//

import SpriteKit

class DialogueManager {
    
    private var notes : [SKSpriteNode] = []
    private var currentAmount : Int = 0
    
    private var iterable : Int = 0
    
    private let firstNum : Int
    private let lastNum : Int
    
    public var nextTextNum : Int
    private var currentNum : Int = 0
    
    private var sets : [Int]
    private var current_set = 0
    
    private var scene : SKScene
    
    init(_ firstNum: Int, _ lastNum : Int, sets: [Int], _ scene: SKScene) {
        self.firstNum = firstNum
        self.lastNum = lastNum
        self.sets = sets
        self.scene = scene
        
        self.nextTextNum = firstNum
    }
    
    public func createNotes(_ positions: [CGPoint], _ quant: Int) {
        var actualQuant : Int = quant
        if nextTextNum + quant - 1 > lastNum {
            actualQuant = lastNum - (nextTextNum + quant - 1)
        }
        
        currentAmount = actualQuant
        
        for i in 0..<actualQuant {
            let actualName = "Text\(nextTextNum + i)"
            let note = SKSpriteNode(imageNamed: actualName)
            
            note.anchorPoint = CGPoint(x: 0, y: 1)
            
            note.position = positions[i]
            note.isHidden = true
            note.setScale(0)
            
            notes.append(note)
            
            scene.addChild(note)
        }
        
        nextTextNum += actualQuant
        
        print(notes.count)
    }
    
    public func showNextNote() -> Bool {
        if iterable == currentAmount {
            return true
        }
        
        let pop = SKAction.scale(to: 1.2, duration: 0.05)
        let mini_shrink = SKAction.scale(to: 1, duration: 0.05)
        let sequence = SKAction.sequence([pop, mini_shrink])
        
        notes[iterable].isHidden = false
        notes[iterable].run(sequence)
        
        iterable += 1
        
        return false
    }
    
    public func destroyAllNotes() {
        if notes.isEmpty {
            return
        }
        
        for note in notes {
            let grow_a_bit = SKAction.scale(to: 1.2, duration: 0.05)
            let shrink_a_bit = SKAction.scale(to: 0, duration: 0.1)
            let wait = SKAction.wait(forDuration: 0.15)
            let destroy = SKAction.run {
                note.removeFromParent()
            }
            
            let sequence = SKAction.sequence([grow_a_bit, shrink_a_bit, wait, destroy])
            
            note.run(sequence)
        }
        
        iterable = 0
        notes.removeAll()
    }
    
    public func isOver() -> Bool {
        if nextTextNum >= lastNum {
            return true
        }
        return false
    }
    
    public func nextDialogue(_ positions: [[CGPoint]]) -> Bool {
        if showNextNote() {
            if isOver() {
                return true
            }
            
            scene.isUserInteractionEnabled = false
            
            destroyAllNotes()
            current_set += 1
            
            let next = SKAction.run {
                self.createNotes(positions[self.current_set], self.sets[self.current_set])
                if self.showNextNote() {
                    return
                }
                self.scene.isUserInteractionEnabled = true
            }
            let wait = SKAction.wait(forDuration: 0.2)
            let sequence = SKAction.sequence([wait, next])
            
            scene.run(sequence)
        }
        
        currentNum += 1
        
        return false
    }
    
    public func getNum() -> Int {
        return currentNum
    }
}
