//
//  GameMenu.swift
//  WWDC24
//
//  Created by Gustavo Binder on 19/02/24.
//

import SpriteKit
import SwiftUI

class Intro : CutScene {

    init() {
        super.init(1, 14, toScene: .game)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setPositions() {
        positions = [[
                        CGPoint(x: 0, y: -20),
                        CGPoint(x: 148, y: -270),
                        CGPoint(x: 0, y: -561)],
                     [
                        CGPoint(x: 75, y: -43),
                        CGPoint(x: 0, y: -228)],
                     [
                        CGPoint(x: 83, y: -20),
                        CGPoint(x: 0, y: -255)],
                     [
                        CGPoint(x: 110, y: -35),
                        CGPoint(x: 0, y: -353)],
                     [
                        CGPoint(x: 183, y: -20),
                        CGPoint(x: 0, y: -211),
                        CGPoint(x: 68, y: -406)],
                     [
                        CGPoint(x: 0, y: -20),
                        CGPoint(x: 0, y: -269),]
        ]
    }
    
    override func setPolkienEmotions() {
        switch (dialogueManager.getNum()) {
        case 2:
            polkien.changePolkien(to: .THINK)
        case 3:
            polkien.changePolkien(to: .APPLE)
        case 5:
            polkien.changePolkien(to: .PINE)
        case 6:
            polkien.changePolkien(to: .HAPPY)
        case 7:
            polkien.changePolkien(to: .NORMAL)
        case 9:
            polkien.changePolkien(to: .THINK)
        case 12:
            polkien.changePolkien(to: .HAPPY)
        default:
            return
        }
    }
    
    override func createSets() {
        all_sets = [3, 2, 2, 2, 3, 2]
    }
    
    override func setPolkienCamera() {
        polkien.changePolkien(to: .CAMERA)
    }
}

