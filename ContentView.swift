import SwiftUI
import _SpriteKit_SwiftUI

struct ContentView: View {
    
    @StateObject var sceneManager : SceneManager = SceneManager()
    
    var body: some View {
        VStack {
            switch sceneManager.current_scene {
            case .menu:
                Button {
                    sceneManager.change_to_intro()
                } label: {
                    Text("Begin")
                }
            case .intro:
                SpriteView(scene: sceneManager.intro_scene)
                    .transition(.opacity)
            case .game:
                GameView()
            case .ending:
                SpriteView(scene: sceneManager.ending_scene)
                    .transition(.opacity)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .environmentObject(sceneManager)
        .onAppear {
            OptionContainer.initialize()
        }
    }
}
