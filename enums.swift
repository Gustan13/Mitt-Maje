//
//  enums.swift
//  WWDC24
//
//  Created by Gustavo Binder on 20/02/24.
//

enum intro_phase {
    case TALKING, CAMERA
}

enum Scenes {
    case menu, intro, game, ending
}

enum picture : String, CaseIterable {
    case NONE = ""
    case HELLO = "Hello"
    case GAMES = "Games"
    case THANKS = "Thank"
    case GIVE = "Give"
    case BANANA = "ThankBanana"
    case EAT = "Eat"
    case MITTMAJE = "MittMaje"
}

enum polkien_image {
    case NORMAL, HAPPY, THINK, APPLE, PINE
}

