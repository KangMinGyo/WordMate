//
//  ResultViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/10/24.
//

import Foundation

final class ResultViewModel {
    
    // MARK: - Properties
    private let question: Question
    private let realmManager: RealmManagerProtocol
    
    var name: String { question.word.name }
    var meaning: String { question.word.meaning }
    var feedback: String { question.isCorrect ? "정답" : "오답" }
    var isLiked: Bool { question.word.isLiked }
    
    // MARK: - Initializer
    init(question: Question, realmManager: RealmManagerProtocol) {
        self.question = question
        self.realmManager = realmManager
    }
    
    // MARK: - Methods
    func toggleIsLiked() {
        let newIsLiked = !isLiked
        realmManager.updateObject(question.word) { $0.isLiked = newIsLiked }
    }
}
