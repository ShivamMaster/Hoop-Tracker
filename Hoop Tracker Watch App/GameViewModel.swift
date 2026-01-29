import SwiftUI
import WatchKit
import Combine

enum GameMode: String, CaseIterable, Identifiable {
    case oneAndTwo = "1s & 2s"
    case twoAndThree = "2s & 3s"
    
    var id: String { self.rawValue }
}   

class GameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var totalPoints: Int {
        didSet { UserDefaults.standard.set(totalPoints, forKey: "totalPoints") }
    }
    @Published var madeShots: Int {
        didSet { UserDefaults.standard.set(madeShots, forKey: "madeShots") }
    }
    @Published var missedShots: Int {
        didSet { UserDefaults.standard.set(missedShots, forKey: "missedShots") }
    }
    @Published var gameMode: GameMode {
        didSet { UserDefaults.standard.set(gameMode.rawValue, forKey: "gameMode") }
    }
    
    // MARK: - Initialization
    init() {
        self.totalPoints = UserDefaults.standard.integer(forKey: "totalPoints")
        self.madeShots = UserDefaults.standard.integer(forKey: "madeShots")
        self.missedShots = UserDefaults.standard.integer(forKey: "missedShots")
        
        if let savedMode = UserDefaults.standard.string(forKey: "gameMode"),
           let mode = GameMode(rawValue: savedMode) {
            self.gameMode = mode
        } else {
            self.gameMode = .oneAndTwo
        }
    }
    
    // MARK: - Computed Properties
    var totalAttempts: Int {
        madeShots + missedShots
    }
    
    var shootingPercentage: Double {
        guard totalAttempts > 0 else { return 0.0 }
        return Double(madeShots) / Double(totalAttempts)
    }
    
    var formattedPercentage: String {
        let percentage = shootingPercentage * 100
        return String(format: "%.1f%%", percentage)
    }
    
    var currentLowPointOption: Int {
        gameMode == .oneAndTwo ? 1 : 2
    }
    
    var currentHighPointOption: Int {
        gameMode == .oneAndTwo ? 2 : 3
    }
    
    // MARK: - Action History
    enum Action {
        case make(points: Int)
        case miss
    }
    
    @Published var actionHistory: [Action] = []
    
    // MARK: - Methods
    
    func addMake(points: Int) {
        totalPoints += points
        madeShots += 1
        actionHistory.append(.make(points: points))
        triggerHaptic(.success)
    }
    
    func addMiss() {
        missedShots += 1
        actionHistory.append(.miss)
        triggerHaptic(.failure)
    }
    
    func undoLastAction() {
        guard let lastAction = actionHistory.popLast() else { return }
        
        switch lastAction {
        case .make(let points):
            totalPoints -= points
            madeShots -= 1
        case .miss:
            missedShots -= 1
        }
        
        triggerHaptic(.directionDown)
    }
    
    func resetStats() {
        totalPoints = 0
        madeShots = 0
        missedShots = 0
        actionHistory.removeAll()
        triggerHaptic(.retry)
    }
    
    func toggleGameMode() {
        if gameMode == .oneAndTwo {
            gameMode = .twoAndThree
        } else {
            gameMode = .oneAndTwo
        }
        triggerHaptic(.directionUp)
    }
    
    private func triggerHaptic(_ type: WKHapticType) {
        WKInterfaceDevice.current().play(type)
    }
}
