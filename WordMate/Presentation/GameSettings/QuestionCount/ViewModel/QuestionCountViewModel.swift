//
//  QuestionCountViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/3/24.
//

import Foundation

final class QuestionCountViewModel {
    
    // MARK: - Properties
    private var count: Int = 20 {
        didSet {
            notifyCountChanged()
        }
    }
    
    var onCountChanged: ((Int) -> Void)?
    var onCountConfirmed: ((Int) -> Void)?
    
    // MARK: - Methods
    func incrementCount(by value: Int) {
        guard value > 0 else { return }
        count += value
    }
    
    func decrementCount(by value: Int) {
        guard value > 0 else { return }
        count = max(5, count - value)
    }
    
    func confirmCount() {
        onCountConfirmed?(count)
    }
    
    private func notifyCountChanged() {
        onCountChanged?(count)
    }
}
