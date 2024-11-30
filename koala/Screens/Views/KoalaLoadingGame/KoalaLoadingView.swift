import SwiftUI

struct KoalaLoadingView: View {
    
    @State var percentageLoadedGame = 0.0
    @State var loadedGame = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("game_name_vertical")
                    .resizable()
                    .frame(width: 250, height: 250)
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .fill(.white)
                        .frame(width: 300, height: 20)
                    
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .fill(Color.init(red: 194/255, green: 0, blue: 183))
                        .frame(width: 300 * percentageLoadedGame, height: 20)
                }
                
                if loadedGame {
                    if UserDefaults.standard.bool(forKey: "passed_boarding_state") {
                        NavigationLink(destination: ContentView()
                            .navigationBarBackButtonHidden(), isActive: $loadedGame) {
                            
                        }
                    } else {
                        NavigationLink(destination: BoardingTutorialVIew()
                            .navigationBarBackButtonHidden(), isActive: $loadedGame) {
                            
                        }
                    }
                }
            }
            .onAppear {
                withAnimation(.interpolatingSpring(duration: 4.0)) {
                    percentageLoadedGame = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    loadedGame = true
                }
            }
            .background(
                Image("game_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    KoalaLoadingView()
}
