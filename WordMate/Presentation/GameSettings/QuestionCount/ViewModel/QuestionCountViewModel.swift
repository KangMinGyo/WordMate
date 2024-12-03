//
//  QuestionCountViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/3/24.
//

import Foundation

class QuestionCountViewModel {
    private var count: Int = 20 {
        didSet {
            onCountChanged?(count)
        }
    }
    
    var onCountChanged: ((Int) -> Void)?
    var onCountConfirmed: ((Int) -> Void)?
    
    func incrementCount(by value: Int) {
        count += value
    }
    
    func decrementCount(by value: Int) {
        if count > value {
            count -= value
        }
    }
    
    func confirmCount() {
        onCountConfirmed?(count)
    }
}
