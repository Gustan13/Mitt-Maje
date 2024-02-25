//
//  CutScene.swift
//  WWDC24
//
//  Created by Gustavo Binder on 25/02/24.
//

import SpriteKit

class CutScene : SKScene {
    let width : Double = UIScreen.main.bounds.width
    let height : Double = UIScreen.main.bounds.height
    
    var sceneManager : SceneManager!
    var dialogueManager : DialogueManager!
    
    var positions : [[CGPoint]] = []
    
    var all_sets : [Int] = []
    
    var polkien : Polkien = Polkien()
    
    private var toScene : Scenes
    
    init(_ first: Int, _ last: Int, toScene: Scenes) {
        let background = SKSpriteNode(imageNamed: "Background 1")
        self.toScene = toScene
        
        super.init(size: CGSize(width: width, height: height))
        
        isUserInteractionEnabled = false
        
        setPositions()
        createSets()
        
        dialogueManager = DialogueManager(first, last, sets: all_sets, self)
        
        self.anchorPoint = CGPoint(x: 0, y: -1)
        
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        background.position = CGPoint(x: width/2, y: -height/2)
        
        addChild(background)
        addChild(polkien)
        
        let position = CGPoint(x: width/2 + polkien.size.width/2, y: (-height) + polkien.size.height/3)
        print(polkien.size.height)
        polkien.setPosition(position: position)
        
        self.scaleMode = .aspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.polkien.setScale(0)
        let wait = SKAction.wait(forDuration: 0.25)
        let show_things = SKAction.run {
            self.polkien.show()
            self.dialogueManager.createNotes(self.positions[0], self.all_sets[0])
            if self.dialogueManager.showNextNote() {
                return
            }
            self.isUserInteractionEnabled = true
        }
        
        let sequence = SKAction.sequence([wait, show_things])
        
        run(sequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dialogueManager.nextDialogue(positions) {
            if (toScene == .game)
            {
                sceneManager.change_to_game()
            }
            else {
                sceneManager.change_to_menu()
            }
        }
        
        setPolkienEmotions()
    }
    
    func setPositions() {
        fatalError("Must override")
    }
    
    func setPolkienEmotions() {
        fatalError("Must override")
    }
    
    func createSets() {
        fatalError("Must override")
    }
}
