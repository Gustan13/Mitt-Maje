//
//  TranslationView.swift
//  WWDC24
//
//  Created by Gustavo Binder on 20/02/24.
//

import SpriteKit
import SwiftUI

enum board_state {
    case APPEARING, STATIC, LEAVING
}

var phrases : [picture : String] = [
    .HELLO : "Gotorova! Za yo Gustavo",
    .GAMES : "Za yo purabi gumen",
    .THANKS : "Paslagora zu",
    .GIVE : "Za yo grimabi zu den borala",
    .BANANA : "Paslagora zu por den borala",
    .EAT : "Za yo orabi den borala",
    .MITTMAJE : "Paslagora zu ka som por purabi MITT MAJE"
]

class PolaroidPuzzle : SKScene {
    
    var sceneManager : SceneManager
    
//    private var optionContainer : OptionContainer = OptionContainer()
    
    private var board : Board!
    private var keyboard : Keyboard!
    private var canvas : WritingCanvas!
    private var returnButton : ExitButton!
    
    private var state : board_state = .APPEARING
    private var picture_at_display : picture
    
    private var correct_flag : Bool = false
    
    init(_ picture_at_display: picture, sm : SceneManager) {
        self.picture_at_display = picture_at_display
        self.board = Board(picture_at_display,
                           picture_at_display == .BANANA || picture_at_display == .THANKS ? (2) : (1))
        self.sceneManager = sm
        
        let width = 820.0
        let height = 1180.0
        
        super.init(size: CGSize(width: width, height: height))
        
        self.returnButton = ExitButton(self)
        self.keyboard = Keyboard(picture_at_display, self)
        self.canvas = WritingCanvas(picture_at_display, self)
        
        addChild(self.board)
        addChild(self.keyboard)
        addChild(self.canvas)
        addChild(self.returnButton)
        
        print(width)
        print(height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.clear
        view.allowsTransparency = true
        view.backgroundColor = SKColor.clear
        
        let board_go = SKAction.run { self.board.drop_down() }
        let canvas_go = SKAction.run { self.canvas.appear() }
        let keyboard_go = SKAction.run { self.keyboard.appear() }
        let show_button = SKAction.run { self.returnButton.pop_up() }
        let wait = SKAction.wait(forDuration: 0.2)
        let wait2 = SKAction.wait(forDuration: 0.25)
        let wait4 = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([wait2, board_go, wait, keyboard_go, canvas_go, wait4, show_button])
        
        run(sequence)
        
        if sceneManager.is_translated(picture_at_display) {
            keyboard.showTranslation()
            canvas.showTranslation()
            isUserInteractionEnabled = true
        } else {
            keyboard.createKeys()
            isUserInteractionEnabled = false
        }
    }
    
    private func isCorrect() -> Bool {
        let answer = OptionContainer.answers[picture_at_display]
        
        if canvas.getPhraseString().count != answer?.count {
            return false
        }
        
        for (n, word) in canvas.getPhraseString().enumerated() {
            
            if word == answer![n] {
                continue
            }
            return false
        }
        
        correct_flag = true
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnToSelection()
    }
}

protocol WritingDelegate {
    func writeWord(_ word: String);
    func eraseWord(_ word: String);
    func checkPhrase();
}

protocol ReturnDelegate {
    func returnToSelection();
}

extension PolaroidPuzzle : WritingDelegate {
    
    func writeWord(_ word: String) {
        canvas.writeWord(word)
        checkPhrase()
    }
    
    func eraseWord(_ word: String) {
        keyboard.addExistingKey(word)
        checkPhrase()
    }
    
    func checkPhrase() {
        
        if !isCorrect() {
            return
        }
        
        let runner = SKAction.run {
            self.keyboard.showTranslation()
            self.canvas.showTranslation()
            self.keyboard.destroyAllKeys()
        }
        
        let wait = SKAction.wait(forDuration: 1.25)
        let go_back = SKAction.run {
            self.returnToSelection()
        }
        
        self.run(SKAction.sequence([runner, wait, go_back]))
    }
}

extension PolaroidPuzzle : ReturnDelegate {
    
    func returnToSelection() {
        run(SKAction.stop())
        
        let board_leave = SKAction.run { self.board.rise_up() }
        let canvas_leave = SKAction.run { self.canvas.disappear() }
        let keyboard_leave = SKAction.run { self.keyboard.disappear() }
        let button_leave = SKAction.run { self.returnButton.shrink_down() }
        
        let wait = SKAction.wait(forDuration: 0.5)
        
        let change_scene = SKAction.run { self.sceneManager.change_polaroid_to(.NONE) }
        
        let update = SKAction.run {
            if self.correct_flag {
                self.sceneManager.next_phase()
            }
        }
        
        OptionContainer.addPhrase(self.picture_at_display, canvas.getPhraseString())
        
        let sequence = SKAction.sequence([button_leave, board_leave, canvas_leave, keyboard_leave, wait, change_scene, update])
        
        run(sequence)
    }
    
}
