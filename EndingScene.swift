//
//  EndingScene.swift
//  WWDC24
//
//  Created by Gustavo Binder on 25/02/24.
//

import SpriteKit

class EndingScene : CutScene {
    
    init() {
        super.init(15, 24)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setPositions() {
        positions = [[
                        CGPoint(x: 0, y: 0),
                        CGPoint(x: 0, y: -223)],
                     [
                        CGPoint(x: 6, y: -198)],
                     [
                        CGPoint(x: 43, y: -32),
                        CGPoint(x: 0, y: -237)],
                     [
                        CGPoint(x: 5, y: 0),
                        CGPoint(x: 20, y: -359)],
                     [
                        CGPoint(x: 3, y: -26),
                        CGPoint(x: 0, y: -311),
                        CGPoint(x: 412, y: -328)]
        ]
    }
    
    override func setPolkienEmotions() {
        switch (dialogueManager.getNum()) {
        case 0:
            polkien.changePolkien(to: .HAPPY)
        case 3:
            polkien.changePolkien(to: .NORMAL)
        case 6:
            polkien.changePolkien(to: .HAPPY)
        case 8:
            polkien.changePolkien(to: .NORMAL)
        default:
            return
        }
    }
    
    override func createSets() {
        all_sets = [2, 1, 2, 2, 3]
    }
}
