import SwiftUI

struct BoardingTutorialVIew: View {
    
    @State var boardingIndex = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $boardingIndex) {
                ForEach(1...8, id: \.self) { indexBoarding in
                    if indexBoarding == 8 {
                        NavigationLink(destination: ContentView()
                            .navigationBarBackButtonHidden()) {
                            Image("boarding_item_8")
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: UIScreen.main.bounds.width,
                                       minHeight: UIScreen.main.bounds.height + 30)
                                .ignoresSafeArea()
                        }
                    } else {
                        ZStack {
                            Image("boarding_item_\(indexBoarding)")
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: UIScreen.main.bounds.width,
                                       minHeight: UIScreen.main.bounds.height + 30)
                                .ignoresSafeArea()
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button {
                                        boardingIndex += 1
                                    } label: {
                                        Rectangle()
                                            .fill(.black.opacity(0))
                                            .frame(width: 200, height: 40)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    BoardingTutorialVIew()
}
