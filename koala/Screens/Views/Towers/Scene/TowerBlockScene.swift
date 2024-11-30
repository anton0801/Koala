import SpriteKit
import SwiftUI

class TowerBlockScene: SKScene, SKPhysicsContactDelegate {
    
    let cameraNode = SKCameraNode()
    var blocks: [SKSpriteNode] = []
    var blockHeight: CGFloat = 60.0
    
    private var currentBlockSize = CGSize(width: 400, height: 60)
    private var initialPositionForPlacedBlock: CGPoint? = nil
    private var currentBlock: SKSpriteNode? = nil
    
    private var homeBtn: SKSpriteNode!
    
    private var balance: Int = UserDefaults.standard.integer(forKey: "balanceCoins")
    private var balanceLabel: SKLabelNode!
    
    private var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    private var scoreLabel: SKLabelNode!
    
    private var speedBlocks = 3.0
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1350)
        physicsWorld.contactDelegate = self
        
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cameraNode)
        
        let backgroundScene = SKSpriteNode(imageNamed: "game_bg")
        backgroundScene.size = size
        // backgroundScene.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundScene.zPosition = -1
        backgroundScene.name = "background_scene_image"
        cameraNode.addChild(backgroundScene)
        
        homeBtn = SKSpriteNode(imageNamed: "home")
        homeBtn.position = CGPoint(x: -300, y: 550)
        homeBtn.size = CGSize(width: 100, height: 100)
        cameraNode.addChild(homeBtn)
        
        let balanceBackground = SKSpriteNode(imageNamed: "coined_balance_bg")
        balanceBackground.position = CGPoint(x: 230, y: 550)
        balanceBackground.size = CGSize(width: 250, height: 100)
        cameraNode.addChild(balanceBackground)
        
        balanceLabel = SKLabelNode(text: "\(balance)")
        balanceLabel.fontName = "Lemon-Regular"
        balanceLabel.fontSize = 32
        balanceLabel.fontColor = .white
        balanceLabel.position = CGPoint(x: 210, y: 540)
        cameraNode.addChild(balanceLabel)
    
        let scoreTitleLabel = SKLabelNode(text: "SCORE")
        scoreTitleLabel.fontName = "Lemon-Regular"
        scoreTitleLabel.fontSize = 52
        scoreTitleLabel.fontColor = UIColor.init(red: 1, green: 214/255, blue: 0, alpha: 1)
        scoreTitleLabel.position = CGPoint(x: 0, y: 440)
        cameraNode.addChild(scoreTitleLabel)
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontName = "Lemon-Regular"
        scoreLabel.fontSize = 52
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 0, y: 380)
        cameraNode.addChild(scoreLabel)
        
        addBlockToScene()
        
        let fundament = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 1))
        fundament.position = CGPoint(x: size.width / 2, y: 1)
        fundament.physicsBody = SKPhysicsBody(rectangleOf: fundament.size)
        fundament.physicsBody?.isDynamic = false
        fundament.physicsBody?.affectedByGravity = false
        addChild(fundament)
    }
    
    func checkAndMoveCamera() {
        if blocks.count % 10 == 0 {
            let newCameraY = cameraNode.position.y + 450
            let moveCameraAction = SKAction.moveTo(y: newCameraY, duration: 0.5)
            cameraNode.run(moveCameraAction)
        }
    }
    
    private func addBlockToScene() {
        let blockSkin = UserDefaults.standard.string(forKey: "selected_block_skin") ?? "block_skin_1"
        let blockY = blocks.count == 0 ? 100 : CGFloat(blocks.count + 1) * blockHeight
        let block = SKSpriteNode(imageNamed: blockSkin)
        block.size = currentBlockSize
        block.position = CGPoint(x: block.size.width / 2, y: blockY)
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody?.isDynamic = true
        block.physicsBody?.affectedByGravity = false
        block.physicsBody?.restitution = 0
        block.physicsBody?.friction = 0
        block.physicsBody?.allowsRotation = false
        block.physicsBody?.categoryBitMask = 1
        block.physicsBody?.collisionBitMask = 1
        block.physicsBody?.contactTestBitMask = 1
        block.name = "block_\(UUID().uuidString)"
        addChild(block)
        
        let moveRight = SKAction.move(to: CGPoint(x: size.width - (block.size.width / 2), y: block.position.y), duration: speedBlocks)
        let moveLeft = SKAction.move(to: CGPoint(x: (block.size.width / 2), y: block.position.y), duration: speedBlocks)
        let seq = SKAction.sequence([moveRight, moveLeft])
        let repeateFor = SKAction.repeatForever(seq)
        block.run(repeateFor)
        
        currentBlock = block
    }
    
    private func placeBlock() {
        if let currentBlock = currentBlock {
            // Остановить текущие действия блока и включить гравитацию
            currentBlock.removeAllActions()
            currentBlock.physicsBody?.affectedByGravity = true
            initialPositionForPlacedBlock = currentBlock.position

            if blocks.count >= 1 {
                // Получить предыдущий блок
                let prevBlock = getPreviusBlock()
                
                // Вычисление границ предыдущего блока
                let prevLeftEdge = prevBlock.position.x - prevBlock.size.width / 2
                let prevRightEdge = prevBlock.position.x + prevBlock.size.width / 2
                
                // Вычисление границ текущего блока
                let currentLeftEdge = currentBlock.position.x - currentBlock.size.width / 2
                let currentRightEdge = currentBlock.position.x + currentBlock.size.width / 2
                
                // Вычисляем пересечение блоков
                let newLeftEdge = max(prevLeftEdge, currentLeftEdge)
                let newRightEdge = min(prevRightEdge, currentRightEdge)
                
                if newLeftEdge < newRightEdge {
                    let newWidth = newRightEdge - newLeftEdge
                    let newPositionX = (newLeftEdge + newRightEdge) / 2
                    
                    currentBlock.size = CGSize(width: newWidth, height: currentBlock.size.height)
                    currentBlock.position.x = newPositionX
                    
                    currentBlockSize = CGSize(width: newWidth, height: currentBlock.size.height)
                }
            }
            blocks.append(currentBlock)

            // Увеличиваем счет и добавляем новый блок
            score += 1
            speedBlocks -= 0.05

            // Задержка перед движением камеры и добавлением нового блока
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checkAndMoveCamera()
                self.addBlockToScene()
            }
        }

        currentBlock = nil
    }
    
    private func getPreviusBlock() -> SKSpriteNode {
        return blocks[blocks.count - 1]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let objects = nodes(at: loc)
            
            for obj in objects {
                if obj == homeBtn {
                    NotificationCenter.default.post(name: Notification.Name("to_home_menu"), object: nil)
                    return
                } else if obj != scoreLabel && obj != balanceLabel {
                    placeBlock()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let initialPositionForPlacedBlock = initialPositionForPlacedBlock {
            if initialPositionForPlacedBlock.y - blocks[blocks.count - 1].position.y > 100 {
                // game over
                NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil, userInfo: ["score": score])
                isPaused = true
            }
        }
    }
    
    func restartTowerBlock() -> TowerBlockScene {
        let newScene = TowerBlockScene()
        view?.presentScene(newScene)
        return newScene
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: TowerBlockScene())
            .ignoresSafeArea()
    }
}
