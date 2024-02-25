//
//  Polaroid.swift
//  WWDC24
//
//  Created by Gustavo Binder on 20/02/24.
//

import SwiftUI

struct Polaroid: View {
    @EnvironmentObject var sceneManager : SceneManager
    
    private var type : picture
    private var phase_appearence : Int
    private var offY : CGFloat
    
    private var image_name : String
    @State private var enabled : Bool = true
    
    init (_ type: picture, _ amount: Int = 1)
    {
        let height = UIScreen.main.bounds.height
        
        self.type = type
        self.phase_appearence = picture.allCases.firstIndex(of: self.type)!
        self.offY = -height
        
        self.image_name = type.rawValue
        
        if amount > 1 {
            self.image_name.append("1")
        }
    }
    
    var body: some View {
        Button {
            sceneManager.change_polaroid_to(type)
            enabled = false
        } label: {
            Image(image_name)
                .saturation(phase_appearence < sceneManager.current_phase ? (1) : (0))
                .padding()
        }
        .offset(x: 0, y: phase_appearence <= sceneManager.current_phase ? (0) : (offY))
        .onChange(of: sceneManager.current_polaroid) { newValue in
            if newValue == .NONE {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.enabled = true
                })
            }
        }
        .disabled(!enabled)
    }
}
