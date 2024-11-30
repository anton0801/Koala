import SwiftUI

struct MissionsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var balance = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70, height: 70)
                }
                Spacer()
                ZStack {
                    Image("coined_balance_bg")
                        .resizable()
                        .frame(width: 150, height: 70)
                    
                    Text("\(balance)")
                        .font(.custom("Lemon-Regular", size: 18))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            
            Image("missions_title")
                .resizable()
                .frame(width: 250, height: 100)
            
            ScrollView {
                VStack {
                    ForEach(allMissions, id: \.id) { mission in
                        ZStack {
                            if mission.passed {
                                Image("mission_passed_bg")
                                    .resizable()
                                    .frame(width: 300, height: 60)
                            } else {
                                Image("mission_not_passed_bg")
                                    .resizable()
                                    .frame(width: 300, height: 60)
                            }
                            
                            HStack {
                                Text(mission.mission)
                                    .font(.custom("Lemon-Regular", size: 14))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if mission.passed {
                                    Image("check")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                }
                                
                                Text("\(mission.reward)")
                                    .font(.custom("Lemon-Regular", size: 14))
                                    .foregroundColor(.white)
                                
                                Image("coin")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                            .padding(.horizontal)
                        }
                        .frame(width: 300, height: 60)
                    }
                }
            }
        }
        .onAppear {
            balance = UserDefaults.standard.integer(forKey: "balanceCoins")
        }
        .onChange(of: balance) { newValue in
            UserDefaults.standard.set(balance, forKey: "balanceCoins")
        }
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width + 60,
                       height: UIScreen.main.bounds.height + 60)
                .blur(radius: 10)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    MissionsView()
}
