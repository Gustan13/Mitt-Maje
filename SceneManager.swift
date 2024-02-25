//
//  SceneManager.swift
//  WWDC24
//
//  Created by Gustavo Binder on 19/02/24.
//

import SwiftUI
import SpriteKit

class SceneManager: ObservableObject {
    
    var intro_scene : Intro!
    var ending_scene : EndingScene!
    var background_scene : Background!
    var puzzle_scene : PolaroidPuzzle!
    
    @Published var current_scene : Scenes = .intro
    @Published var current_polaroid : picture = .NONE
    @Published var current_phase : Int = 0
    
    init() {
        intro_scene = Intro()
        ending_scene = EndingScene()
        background_scene = Background()
        
        intro_scene.scaleMode = .aspectFill
        ending_scene.scaleMode = .aspectFill
        background_scene.scaleMode = .aspectFill
        
        intro_scene.sceneManager = self
        ending_scene.sceneManager = self
    }
    
    func change_to_menu()
    {
        withAnimation {
            self.current_scene = .menu
        }
    }
    func change_to_intro()
    {
        withAnimation {
            self.current_scene = .intro
        }
    }
    func change_to_game()
    {
        withAnimation {
            self.current_scene = .game
        }
    }
    func change_to_ending()
    {
        withAnimation {
            self.current_scene = .ending
        }
    }
    
    func change_polaroid_to(_ type: picture)
    {
        withAnimation {
            self.current_polaroid = type
            print(self.current_polaroid)
        }
        if self.current_polaroid != .NONE {
            self.puzzle_scene = PolaroidPuzzle(self.current_polaroid, sm: self)
            self.puzzle_scene.backgroundColor = SKColor.clear
            self.puzzle_scene.view?.allowsTransparency = true
            self.puzzle_scene.view?.backgroundColor = SKColor.clear
        }
    }
    
    func next_phase() {
        if current_phase <= picture.allCases.count {
            withAnimation(.linear(duration: 0.5)) {
                current_phase += 1
                if current_phase == picture.allCases.count {
                    let wait = SKAction.wait(forDuration: 1.2)
                    let runthing = SKAction.run {
                        self.change_to_ending()
                    }
                    let sequence = SKAction.sequence([wait, runthing])
                    
                    background_scene.run(sequence)
                } else {
                    background_scene.flashAction()
                }
            }
        }
    }
    
    func is_translated(_ picture_displayed: picture) -> Bool {
        for (n, polaroid) in picture.allCases.enumerated() {
            if polaroid != picture_displayed {
                continue
            }
            if n < current_phase {
                return true
            }
        }
        return false
    }
}
