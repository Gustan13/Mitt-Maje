//
//  MainMenu.swift
//  WWDC24
//
//  Created by Gustavo Binder on 25/02/24.
//

import SwiftUI

struct MainMenu: View {
    
    @EnvironmentObject var sceneManager : SceneManager
    
    @State var off1 : CGFloat = -1000
    @State var off2 : CGFloat = 1000
    @State var visible : Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("AllPolaroids1")
                    .offset(y: off1)
                Image("AllPolaroids2")
                    .offset(y: off2)
            }
            VStack {
                Image("HiddenText")
                    .padding(100)
                    .scaleEffect(CGSize(width: visible ? (1) : (0), height: visible ? (1) : (0)))
                    .transition(.opacity)
                Image("MittMaje")
                    .scaleEffect(CGSize(width: visible ? (1.5) : (0), height: visible ? (1.5) : (0)))
                    .transition(.scale)
                    .padding()
                Button {
                    sceneManager.change_to_intro()
                } label: {
                    ZStack {
                        Image("Paper")
                        Text("Go to Intro")
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                    }
                }
                .padding(100)
                .offset(y: off2 + 100)
            }
        }
        .background(.black)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    off1 = 100
                    off2 = -100
                    visible = true
                }
            })
        }
    }
}

#Preview {
    MainMenu()
}
