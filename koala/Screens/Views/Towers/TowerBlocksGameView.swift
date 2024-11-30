import SwiftUI
import SpriteKit

struct TowerBlocksGameView: View {
    
    @Environment(\.presentationMode) var presMode
    @State var gameOver = false
    @State var score = 0
    
    @State var doubleWin = false
    @State var doubleWinOver = false
    
    @State var towerBlockScene: TowerBlockScene!
    @State var balance = 0
    
    var body: some View {
        ZStack {
            VStack {
                if let towerBlockScene = towerBlockScene {
                    SpriteView(scene: towerBlockScene)
                        .ignoresSafeArea()
                }
            }
            
            if gameOver {
                gameOverView
            }
            
            if doubleWin {
                if doubleWinOver {
                    doubleWinOverView
                } else {
                    doubleWinView
                }
            }
        }
        .onAppear {
            towerBlockScene = TowerBlockScene()
            balance = UserDefaults.standard.integer(forKey: "balanceCoins")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("to_home_menu"))) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onChange(of: balance) { newValue in
            UserDefaults.standard.set(balance, forKey: "balanceCoins")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_over"))) { notification in
            if let userInfo = notification.userInfo as? [String: Any],
               let score = userInfo["score"] as? Int {
                self.score = score
                withAnimation(.easeInOut) {
                    self.gameOver = true
                }
            }
        }
    }
    
    private var gameOverView: some View {
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
            
            Image("game_over_title")
                .resizable()
                .frame(width: 250, height: 100)
            
            ZStack {
                Image("score_bg")
                    .resizable()
                    .frame(width: 200, height: 100)
                
                Text("\(score)")
                    .font(.custom("Lemon-Regular", size: 32))
                    .foregroundColor(.white)
                    .padding(.top)
            }
            
            Text("Double your\nwinnings")
                .font(.custom("Lemon-Regular", size: 24))
                .foregroundColor(Color.init(red: 1, green: 229/255, blue: 0))
                .multilineTextAlignment(.center)
                .padding(.top)
                .shadow(color: Color.init(red: 1, green: 107/255, blue: 0), radius: 1, x: -1)
                .shadow(color: Color.init(red: 1, green: 107/255, blue: 0), radius: 1, x: 1)
            
            Image("double_roulette_preview")
                .resizable()
                .frame(width: 250, height: 250)
            
            HStack {
                Button {
                    withAnimation(.easeInOut) {
                        doubleWin = true
                    }
                } label: {
                    Image("play_btn")
                        .resizable()
                        .frame(width: 170, height: 80)
                }
                
                Button {
                    towerBlockScene = towerBlockScene.restartTowerBlock()
                    withAnimation(.easeInOut) {
                        gameOver = false
                    }
                } label: {
                    Image("restart")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
            }
            
            Spacer()
            
        }
        .background(
            Image("game_over_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    @State private var rotationAngle: Double = 0
    @State private var selectedPrize: Int = 0
    @State private var isSpinning: Bool = false
    
    private let prizeAngles: [(angle: Double, prize: Int)] = [
        (angle: 0, prize: 3),
        (angle: 120, prize: 0),
        (angle: 240, prize: 10)
    ]
    
    private var doubleWinView: some View {
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
            
            Image("double_your_winnings")
                .resizable()
                .frame(width: 250, height: 130)
            
            ZStack {
                Image("score_bg")
                    .resizable()
                    .frame(width: 200, height: 100)
                
                Text("\(score)")
                    .font(.custom("Lemon-Regular", size: 32))
                    .foregroundColor(.white)
                    .padding(.top)
            }
            
            ZStack {
                Image("roulette_bg")
                    .resizable()
                    .frame(width: 250, height: 350)
                
                Image("roulette")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .rotationEffect(.degrees(rotationAngle))
                    .offset(y: -50)
                
                Image("roulette_indicator")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .offset(y: -165)
                
                Button {
                    spinRoulette()
                } label: {
                    Image("spin_btn")
                        .resizable()
                        .frame(width: 150, height: 70)
                }
                .offset(y: 165)
            }
            
            Spacer()
        }
        .background(
            Image("game_over_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private var doubleWinOverView: some View {
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
            
            Image("you_win")
                .resizable()
                .frame(width: 200, height: 100)
            
            ZStack {
                Image("score_bg")
                    .resizable()
                    .frame(width: 200, height: 100)
                
                Text("\(score)")
                    .font(.custom("Lemon-Regular", size: 32))
                    .foregroundColor(.white)
                    .padding(.top)
            }
            
            Button {
                towerBlockScene = towerBlockScene.restartTowerBlock()
                withAnimation(.easeInOut) {
                    gameOver = false
                    doubleWin = false
                    doubleWinOver = false
                }
            } label: {
                Image("play_btn")
                    .resizable()
                    .frame(width: 250, height: 120)
            }
            
            Spacer()
        }
        .background(
            Image("game_over_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private func spinRoulette() {
        guard !isSpinning else { return }
        isSpinning = true
        
        // Выбираем случайный угол и выигрыш
        let selected = prizeAngles.randomElement()!
        let spins: CGFloat = 3 * 360
        let finalAngle = spins + selected.angle
        
        withAnimation(.easeOut(duration: 5)) {
            rotationAngle += finalAngle
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            rotationAngle = finalAngle.truncatingRemainder(dividingBy: 360)
            selectedPrize = selected.prize
            isSpinning = false
            if selectedPrize != 0 {
                score = score * selectedPrize
            }
            withAnimation(.easeInOut) {
                self.doubleWinOver = true
            }
        }
    }
    
}

#Preview {
    TowerBlocksGameView()
}
