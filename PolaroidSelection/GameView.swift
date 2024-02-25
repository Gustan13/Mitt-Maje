//
//  GameView.swift
//  WWDC24
//
//  Created by Gustavo Binder on 19/02/24.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct GameView : View {
    
    @EnvironmentObject var sceneManager : SceneManager
    
    var body: some View {
        ZStack {
            SpriteView(scene: sceneManager.background_scene)
            VStack {
                Grid {
                    GridRow {
                        Polaroid(.HELLO)
                        Polaroid(.GAMES)
                        Polaroid(.THANKS, 2)
                    }
                    GridRow {
                        Polaroid(.GIVE)
                        Polaroid(.BANANA, 2)
                        Polaroid(.EAT)
                    }
                }
                Polaroid(.MITTMAJE)
            }
            if sceneManager.current_polaroid != .NONE {
                SpriteView(scene: sceneManager.puzzle_scene, options: [.allowsTransparency])
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                sceneManager.next_phase()
            }
        }
    }
    
}
