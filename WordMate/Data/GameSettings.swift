//
//  GameSettings.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import Foundation

struct GameSettings {
    let includeBookmarkWords: Bool
    let questionOrder: QuestionOrder
    let questionCount: Int
}

enum QuestionOrder: String {
    case sequential = "순서대로"
    case random = "랜덤"
    case reverse = "거꾸로"
}
