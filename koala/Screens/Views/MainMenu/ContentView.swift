import SwiftUI

struct ContentView: View {
    
    @State var settingsVisible = false
    
    @State var isMusicOn = false
    @State var isVibrOn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("game_name_horizontal")
                        .resizable()
                        .frame(width: 250, height: 100)
                    
                    NavigationLink(destination: TowerBlocksGameView()
                        .navigationBarBackButtonHidden()) {
                        Image("play_btn")
                            .resizable()
                            .frame(width: 200, height: 100)
                    }
                    
                    Spacer()
                        
                    HStack {
                        NavigationLink(destination: ShopView()
                            .navigationBarBackButtonHidden()) {
                            Image("shop")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        NavigationLink(destination: MissionsView()
                            .navigationBarBackButtonHidden()) {
                            Image("missions")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        Button {
                            withAnimation(.easeInOut) {
                                settingsVisible = true
                            }
                        } label: {
                            Image("settings")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                
                if settingsVisible {
                    settingsView
                }
            }
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "passed_boarding_state") {
                    UserDefaults.standard.set(true, forKey: "passed_boarding_state")
                }
                
                isMusicOn = UserDefaults.standard.bool(forKey: "is_music_on")
                isVibrOn = UserDefaults.standard.bool(forKey: "is_vibr_on")
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
    
    private var settingsView: some View {
        VStack {
            VStack {
                HStack {
                    Image("close_btn")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .opacity(0)
                    
                    Image("settings_title")
                        .resizable()
                        .frame(width: 120, height: 60)
                    
                    Button {
                        withAnimation(.linear) {
                            settingsVisible = false
                        }
                    } label: {
                        Image("close_btn")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                
                HStack {
                    Text("Music")
                        .font(.custom("Lemon-Regular", size: 18))
                        .foregroundColor(Color.init(red: 238/255, green: 214/255, blue: 0))
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut) {
                            isMusicOn = !isMusicOn
                        }
                    } label: {
                        Image("arrow_back")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    
                    Text(isMusicOn ? "on" : "off")
                        .font(.custom("Lemon-Regular", size: 18))
                        .foregroundColor(.white)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            isMusicOn = !isMusicOn
                        }
                    } label: {
                        Image("arrow_forward")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Vibration")
                        .font(.custom("Lemon-Regular", size: 18))
                        .foregroundColor(Color.init(red: 238/255, green: 214/255, blue: 0))
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut) {
                            isVibrOn = !isVibrOn
                        }
                    } label: {
                        Image("arrow_back")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    
                    Text(isVibrOn ? "on" : "off")
                        .font(.custom("Lemon-Regular", size: 18))
                        .foregroundColor(.white)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            isVibrOn = !isVibrOn
                        }
                    } label: {
                        Image("arrow_forward")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    
                }
                .padding(.horizontal)
                
                
            }
            .onChange(of: isMusicOn, perform: { newValue in
                UserDefaults.standard.set(newValue, forKey: "is_music_on")
            })
            .onChange(of: isVibrOn, perform: { newValue in
                UserDefaults.standard.set(newValue, forKey: "is_vibr_on")
            })
            .frame(width: 250, height: 200)
            .background(
                Image("settings_bg")
                    .resizable()
                    .frame(width: 250, height: 200)
            )
        }
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.5)
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .ignoresSafeArea()
        )
    }
    
}

#Preview {
    ContentView()
}
