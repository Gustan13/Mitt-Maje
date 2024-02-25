//
//  OptionContainer.swift
//  WWDC24
//
//  Created by Gustavo Binder on 20/02/24.
//
import SwiftUI

class OptionContainer : ObservableObject {
    
    static var answers : [picture : [String]] = [:]
    static var current_phrases : [picture : [String]] = [:]
    static var options : [picture : [Int]] = [:]
    
    static var all_options : [String] = [
        "hello!",
        "cherry",
        "you",
        "I",
        "Gustavo",
        "basket",
        "am",
        "football",
        "banana",
        "game",
        "thank",
        "my",
        "basketball",
        "soda",
        "bowl",
        "playing",
        "like",
        "luggage",
        "are",
        "eating",
        "ate",
        "the",
        "giving",
        "so",
        "much",
        "oranges",
        "do",
        "pie",
        "for",
        "very",
        "games"
    ]
    
//    static var main = OptionContainer()
    
    static func initialize() {
        
        options = [
            .HELLO: [0, 3, 6, 4],
            .GAMES: [3, 6, 15, 30],
            .THANKS: [10, 2],
            .GIVE: [3, 6, 22, 2, 21, 8],
            .BANANA: [10, 2, 28, 21, 8],
            .EAT: [3, 6, 19, 21, 8],
            .MITTMAJE: [10, 2, 23, 24, 28, 15, 11, 9]
        ]
        
        for option in picture.allCases {
            
            if option == .NONE {
                continue
            }
            
            current_phrases.updateValue([], forKey: option)
            answers.updateValue([], forKey: option)
            
            for i in options[option]!
            {
                answers[option]!.append(all_options[i])
            }
            
            for _ in 0..<(12 - options[option]!.count) {
                
                var random_option = Int.random(in: 0...28)
                
                while options[option]!.contains(random_option) {
                    random_option = Int.random(in: 0...28)
                }
                
                options[option]!.append(random_option)
            }
            
            options[option]!.shuffle()
        }
        
    }
    
    static func getCurrentPhrases(_ type: picture) -> [String] {
        return current_phrases[type]!
    }
    
    static func addPhrase(_ type: picture, _ phrase: [String]) {
        current_phrases.updateValue(phrase, forKey: type)
        print(current_phrases)
    }
}
