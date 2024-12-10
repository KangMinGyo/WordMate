//
//  ResultViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/10/24.
//

import Foundation

class ResultViewModel {
    private let question: Question
    private let realmManager: RealmManagerProtocol
    
    init(question: Question, realmManager: RealmManagerProtocol) {
        self.question = question
        self.realmManager = realmManager
    }
    
    var name: String {
        return question.word.name
    }
    
    var meaning: String {
        return question.word.meaning
    }
    
    var feedback: String {
        return question.isCorrect ? "정답" : "오답"
    }
    
    var isLiked: Bool {
        return question.word.isLiked
    }
    
    func updateIsLiked() {
        let newIsLiked = !isLiked
        realmManager.updateIsLiked(for: question.word, to: newIsLiked)
        print("newIsLiked : \(newIsLiked)")
    }
    
}
