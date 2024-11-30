import Foundation

struct MissionItem {
    let id: String
    let mission: String
    let reward: Int
    let passed: Bool
}

let allMissions = [
    MissionItem(id: "build_25_blocks", mission: "Build 25 blocks in one game", reward: 50, passed: UserDefaults.standard.bool(forKey: "build_25_blocks")),
    MissionItem(id: "build_50_blocks", mission: "Build 50 blocks in one game", reward: 50, passed: UserDefaults.standard.bool(forKey: "build_50_blocks")),
    MissionItem(id: "place_exact_5", mission: "Place exactly 5 blocks in a row perfectly", reward: 100, passed: UserDefaults.standard.bool(forKey: "place_exact_5")),
    MissionItem(id: "score_100_points", mission: "Score 100 points", reward: 100, passed: UserDefaults.standard.bool(forKey: "score_100_points")),
    MissionItem(id: "tower_100_blocks", mission: "Build a tower of 100 blocks across all games", reward: 100, passed: UserDefaults.standard.bool(forKey: "tower_100_blocks")),
    MissionItem(id: "place_exact_3", mission: "Make 3 perfect placements in a row.", reward: 50, passed: UserDefaults.standard.bool(forKey: "place_exact_3")),
    MissionItem(id: "score_200_points", mission: "Score 200 points in one game", reward: 50, passed: UserDefaults.standard.bool(forKey: "score_200_points")),
    MissionItem(id: "build_75_blocks", mission: "Build 75 blocks in one game", reward: 100, passed: UserDefaults.standard.bool(forKey: "build_75_blocks"))
]
