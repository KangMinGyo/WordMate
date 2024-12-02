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

enum QuestionOrder {
    case sequential
    case random
}
