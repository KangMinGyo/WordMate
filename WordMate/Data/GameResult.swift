//
//  GameResult.swift
//  WordMate
//
//  Created by KangMingyo on 12/9/24.
//

import Foundation

struct GameResult {
    let questions: [Question]
    
    var correctAnswers: Int {
        questions.filter { $0.isCorrect }.count
    }
    
    var wrongAnswers: Int {
        questions.filter { !$0.isCorrect }.count
    }
    
    var totalQuestions: Int {
        questions.count
    }
}
