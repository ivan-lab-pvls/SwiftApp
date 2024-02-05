//
//  Game.swift
//  Mystake
//
//  Created by Vladko on 18.01.2024.
//

import UIKit

enum Game {
    
    /// Fortune wheel
    case fortuneWheel
    
    /// Mines
    case mines
    
    /// Cups
    case cups
    
    /// Luck catcher
    case luckCatcher
    
}

extension Game {
    
    /// Poster
    var poster: UIImage? {
        switch self {
        case .fortuneWheel:
            return Images.gameFortune
        case .mines:
            return Images.gameMines
        case .cups:
            return Images.gameCups
        case .luckCatcher:
            return Images.gameLuckCatcher
        }
    }
    
    /// Name
    var name: String {
        switch self {
        case .fortuneWheel:
            return "Fortune wheel"
        case .mines:
            return "Mines"
        case .cups:
            return "Cups"
        case .luckCatcher:
            return "Lick catcher"
        }
    }
    
    /// Rules
    var rules: String? {
        switch self {
        case .mines:
            return "Game field is full of bombs and cherries.\n\nYou always have 3 bombs there. You have to collect all cherries before you’ll blow up.\n\nEvery cherry you get gives you o.2 to the bet you made. You can cah out any time. So if you find all cherries before you catch the bomb, you’ll get x2 to your bet.\n\nIf you blow up, your bet will be lost.\n\nGood luck!"
        case .cups:
            return "You see 5 cups on a screen.\n\nOne of them is hiding a ball. Try to guess which one.\n\nIf you’re right, you’ll get x2 to your bet.\n\nGood luck!"
        case .luckCatcher:
            return "25 numbers on the filed — you need to pick your 3 favorite.\n\nAfter picking, you’ll need to catch the Luck. Randomly will be chosen 3 numbers. If it’s your numbers, you get x4 to your bet!\n\n1 Lucky number — x2\n2 Lucky numbers — x3\n3 Lucky numbers — x4\n\nGood luck!"
        default:
            return nil
        }
    }
    
}
