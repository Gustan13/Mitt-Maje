//
//  Polkien.swift
//  WWDC24
//
//  Created by Gustavo Binder on 24/02/24.
//

import SpriteKit

class Polkien : SKSpriteNode {
    
    private var happy : SKTexture
    private var normal : SKTexture
    private var think : SKTexture
    private var apple : SKTexture
    private var pine : SKTexture
    
    private var current_image : polkien_image
    
    init() {
        happy = SKTexture(imageNamed: "PolkienHappy")
        normal = SKTexture(imageNamed: "PolkienNormal")
        think = SKTexture(imageNamed: "PolkienThink")
        apple = SKTexture(imageNamed: "PolkienApple")
        pine = SKTexture(imageNamed: "PolkienPine")
        
        current_image = .NORMAL
        
        print(normal.size())
        
        super.init(texture: normal, color: .white, size: normal.size())
        
//        run(SKAction.hide())
        zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changePolkien(to polkien_type: polkien_image) {
        current_image = polkien_type
        
        let change = SKAction.run {
            self.changeImage(to: polkien_type)
        }
        let wait = SKAction.wait(forDuration: 0.05)
        let sequence = SKAction.sequence([wait, change])
        
        show()
        run(sequence)
    }
    
    private func changeImage(to pt: polkien_image) {
        switch (current_image) {
        case .NORMAL:
            self.texture = normal
        case .HAPPY:
            self.texture = happy
        case .THINK:
            self.texture = think
        case .APPLE:
            self.texture = apple
        case .PINE:
            self.texture = pine
        }
        
        self.size = self.texture!.size()
    }
    
    public func setPosition(position: CGPoint) {
        self.position = position
    }
    
    public func hide() {
        let hide = SKAction.hide()
        let over_grow = SKAction.scale(to: 1.2, duration: 0.05)
        let shrink = SKAction.scale(to: 0, duration: 0.1)
        let wait = SKAction.wait(forDuration: 0.15)
        let sequence = SKAction.sequence([over_grow, shrink, wait, hide])
        
        run(sequence)
    }
    
    public func show() {
        let show = SKAction.unhide()
        let over_grow = SKAction.scale(to: 1.2, duration: 0.05)
        let shrink = SKAction.scale(to: 1, duration: 0.05)
        let wait = SKAction.wait(forDuration: 0.1)
        let sequence = SKAction.sequence([over_grow, shrink, wait, show])
        
        run(sequence)
    }
    
}
