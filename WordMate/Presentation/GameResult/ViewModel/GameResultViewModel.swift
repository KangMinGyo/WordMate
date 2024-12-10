//
//  GameResultViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/10/24.
//

import Foundation

class GameResultViewModel {
    private let questions: [Question]
    
    init(questions: [Question]) {
        self.questions = questions
    }
    
    var correctAnswers: Int {
        questions.filter { $0.isCorrect }.count
    }
    
    var wrongAnswers: Int {
        questions.filter { !$0.isCorrect }.count
    }
    
    var totalQuestions: Int {
        questions.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return questions.count
    }
    
    func memberViewModelAtIndex(_ index: Int) -> ResultViewModel {
        let question = questions[index]
        return ResultViewModel(question: question, realmManager: RealmManager())
    }
}
