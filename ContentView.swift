import SwiftUI
import _SpriteKit_SwiftUI

func doubleSize(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width * 2, height: size.height * 2)
}

struct ContentView: View {
    
    @StateObject var sceneManager : SceneManager = SceneManager()
    
    var body: some View {
        VStack {
            ZStack {
                switch sceneManager.current_scene {
                case .menu:
                    MainMenu()
                case .intro:
                    SpriteView(scene: sceneManager.intro_scene)
                        .transition(.opacity)
                case .game:
                    GameView()
                case .ending:
                    SpriteView(scene: sceneManager.ending_scene)
                        .transition(.opacity)
                }
                
                if sceneManager.flash {
                    VStack {}
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.opacity)
                        .background(Color.white)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                withAnimation {
                                    sceneManager.flash = false
                                }
                            })
                        }
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .environmentObject(sceneManager)
        .onAppear {
            OptionContainer.initialize()
        }
    }
}
