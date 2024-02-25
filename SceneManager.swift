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
    
    @Published var current_scene : Scenes = .menu
    @Published var current_polaroid : picture = .NONE
    @Published var current_phase : Int = 0
    
    @Published var flash : Bool = false
    @Published var isDone : Bool = false
    
    init() {
        self.background_scene = Background()
        
        self.background_scene.scaleMode = .aspectFill
    }
    
    func change_to_menu()
    {
        withAnimation {
            flash = true
            self.current_scene = .menu
        }
    }
    func change_to_intro()
    {
        self.intro_scene = Intro()
        self.intro_scene.sceneManager = self
        self.intro_scene.scaleMode = .aspectFill
        
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
        self.ending_scene = EndingScene()
        self.ending_scene.sceneManager = self
        self.ending_scene.scaleMode = .aspectFill
        
        withAnimation {
            flash = true
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
            self.puzzle_scene.scaleMode = .aspectFill
        }
    }
    
    func next_phase() {
        if current_phase <= picture.allCases.count {
            withAnimation(.linear(duration: 0.5)) {
                current_phase += 1
                if current_phase == picture.allCases.count {
                    print("Changing")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.change_to_ending()
                    })
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
