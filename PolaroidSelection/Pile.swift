//
//  Pile.swift
//  WWDC24
//
//  Created by Gustavo Binder on 19/02/24.
//

import SpriteKit

class Pile {
    
    var game : Background
    var sprite : SKSpriteNode
    var pile_const : Int
    var pile_progress : Int = 0
    var next_y_position : CGFloat
    
    init(sprite: String, pile_const: Int, x: Int, game: Background) {
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.position = CGPoint(x: x, y: Int(-self.sprite.size.height/2))
        self.pile_const = pile_const
        self.game = game
        self.next_y_position = self.sprite.position.y
    }
    
    public func grow_up()
    {
        sprite.run(SKAction.run {
            if self.next_y_position + CGFloat(self.pile_const) < self.sprite.size.height/2 {
                self.sprite.run(SKAction.move(by: CGVector(dx: 0, dy: self.pile_const), duration: 1))
                self.next_y_position += CGFloat(self.pile_const)
            }
        })
    }
}
