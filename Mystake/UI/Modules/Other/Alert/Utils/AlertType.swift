//
//  AlertType.swift
//  Mystake
//
//  Created by Vladko on 19.01.2024.
//

import UIKit

enum AlertType {
    
    /// Cherries done
    case minesWin(Double)
    
    /// Mines lose
    case minesLose
    
    
    /// Lucky win
    case luckyWin(Double, Double)
    
    
    /// Cups win
    case cupsWin(Double)
    
    /// Cups lose
    case cupsLose(Double)
    
    
    /// Wheel win
    case wheelWin(Double, Double)
    
}

extension AlertType {
    
    /// Image
    var image: UIImage? {
        switch self {
        case .minesWin:
            return Images.cherry
        case .minesLose:
            return Images.mines
        default:
            return nil
        }
    }
    
    /// Shadow
    var shadow: UIColor {
        switch self {
        case .minesWin:
            return .gradientGreen2
        case .minesLose:
            return .gradientOrange2
        default:
            return .clear
        }
    }
    
    /// Amount
    var amount: Double? {
        switch self {
        case .minesWin(let amount),
             .cupsWin(let amount),
             .cupsLose(let amount):
            return amount
        case .luckyWin(_, let amount),
             .wheelWin(_, let amount):
            return amount
        default:
            return nil
        }
    }
    
    /// Title
    var title: String {
        switch self {
        case .minesWin:
            return "Cherries done"
        case .minesLose:
            return "Blow up"
        case .luckyWin(let multiplier, _),
             .wheelWin(let multiplier, _):
            let nf = NumberFormatter()
            nf.minimumFractionDigits = 0
            let multiplier = nf.string(from: .init(floatLiteral: multiplier)) ?? ""
            return "x\(multiplier) to your bet"
        case .cupsWin:
            return "You win"
        case .cupsLose:
            return "You lose"
        }
    }
    
}
