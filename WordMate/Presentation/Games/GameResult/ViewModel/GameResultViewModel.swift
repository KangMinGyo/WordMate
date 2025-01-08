//
//  GameResultViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/10/24.
//

import Foundation

final class GameResultViewModel {
    
    // MARK: - Properties
    private let questions: [Question]
    private let realmManager: RealmManagerProtocol
    
    var totalQuestions: Int {
        questions.count
    }
    
    var correctAnswers: Int {
        questions.filter { $0.isCorrect }.count
    }
    
    var wrongAnswers: Int {
        totalQuestions - correctAnswers
    }
    
    // MARK: - Initializer
    init(questions: [Question], realmManager: RealmManagerProtocol) {
        self.questions = questions
        self.realmManager = realmManager
    }
    
    // MARK: - Methods
    func numberOfRowsInSection(_ section: Int) -> Int {
        return questions.count
    }
    
    func memberViewModel(at index: Int) -> ResultViewModel {
        let question = questions[index]
        return ResultViewModel(question: question, realmManager: realmManager)
    }
}
