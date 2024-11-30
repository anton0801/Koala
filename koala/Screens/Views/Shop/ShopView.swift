import SwiftUI

struct ShopView: View {
    
    @Environment(\.presentationMode) var presMode
    @State var balance = 0
    
    @State private var purchasedItems: Set<Int> = []
    
    private let totalItems = 18
    private let purchasedKey = "purchasedBlockItems"
    
    @State var alertVisible = false
    @State var alertMessage = ""
    
    @State var selectedBlockItemName = ""
    
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
            
            Image("shop_title")
                .resizable()
                .frame(width: 250, height: 120)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(180)),
                    GridItem(.fixed(180))
                ]) {
                    ForEach(1...totalItems, id: \.self) { blockIndex in
                        let blockItem = createBlockItem(id: blockIndex)
                        ZStack {
                            if selectedBlockItemName == blockItem.name {
                                Image("selected_overlay")
                                    .resizable()
                                    .frame(width: 180, height: 120)
                            } else {
                                Image("default_overlay")
                                    .resizable()
                                    .frame(width: 180, height: 120)
                            }
                            
                            Image(blockItem.name)
                                .resizable()
                                .frame(width: 140, height: 80)
                                .cornerRadius(16)
                            
                            if selectedBlockItemName == blockItem.name {
                                
                            } else {
                                if !isPurchased(item: blockItem) {
                                    Rectangle()
                                        .fill(.gray)
                                        .opacity(0.8)
                                        .frame(width: 140, height: 80)
                                        .cornerRadius(16)
                                    
                                    Image("coined_balance_bg")
                                        .resizable()
                                        .frame(width: 100, height: 50)
                                    
                                    Button {
                                        purchase(item: blockItem)
                                    } label: {
                                        Text("\(blockItem.price)")
                                            .font(.custom("Lemon-Regular", size: 14))
                                            .foregroundColor(.white)
                                            .offset(x: -10)
                                    }
                                } else {
                                    Button {
                                        withAnimation(.easeInOut) {
                                            selectedBlockItemName = blockItem.name
                                        }
                                    } label: {
                                        Rectangle()
                                            .fill(.white)
                                            .opacity(0)
                                            .frame(width: 140, height: 80)
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            loadPurchasedItems()
            balance = UserDefaults.standard.integer(forKey: "balanceCoins")
            selectedBlockItemName = UserDefaults.standard.string(forKey: "selected_block_skin") ?? "block_skin_1"
        }
        .onChange(of: balance) { newValue in
            UserDefaults.standard.set(balance, forKey: "balanceCoins")
        }
        .alert(isPresented: $alertVisible, content: {
            Alert(title: Text("Alert!"), message: Text(alertMessage))
        })
        .background(
            Image("game_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width + 60,
                       height: UIScreen.main.bounds.height + 60)
                .blur(radius: 10)
                .ignoresSafeArea()
        )
    }
    
    private func createBlockItem(id: Int) -> BlockItem {
        return BlockItem(id: id, name: "block_skin_\(id)", price: 1000)
    }
    
    func purchase(item: BlockItem) {
        guard !isPurchased(item: item) else {
            return
        }
        
        guard balance >= item.price else {
            alertMessage = "You don't have enought coins to buy this skin for blocks!"
            alertVisible = true
            return
        }
        
        balance -= item.price
        purchasedItems.insert(item.id)
        savePurchasedItems()
        
        alertMessage = "Purchases success!"
        alertVisible = true
    }
    
    // Метод проверки, куплен ли BlockItem
    func isPurchased(item: BlockItem) -> Bool {
        return purchasedItems.contains(item.id)
    }
    
    private func loadPurchasedItems() {
        if let savedItems = UserDefaults.standard.array(forKey: purchasedKey) as? [Int] {
            purchasedItems = Set(savedItems)
            
            if purchasedItems.count == 0 {
                purchase(item: BlockItem(id: 1, name: "block_skin_1", price: 0))
            }
        }
    }
    
    // Сохранение купленных предметов в UserDefaults
    private func savePurchasedItems() {
        UserDefaults.standard.set(Array(purchasedItems), forKey: purchasedKey)
    }
    
}

#Preview {
    ShopView()
}

struct BlockItem: Identifiable {
    let id: Int
    let name: String
    let price: Int
}
