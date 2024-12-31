//
//  QuestionOrderViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/4/24.
//

import Foundation

final class QuestionOrderViewModel {
    
    // MARK: - Properties
    private var options = ["순서대로", "랜덤", "거꾸로"]
    private var selectedIndex: Int?
    
    var onQuestionOrderSelected: ((QuestionOrder?) -> Void)?
    
    // MARK: - Public Methods
    func numberOfRowsInSection() -> Int {
        return options.count
    }
    
    func option(at indexPath: IndexPath) -> String {
        return options[indexPath.row]
    }
    
    func isSelected(at indexPath: IndexPath) -> Bool {
        return indexPath.row == selectedIndex
    }
    
    func selectOption(at indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    func currentSelection() -> QuestionOrder {
        switch selectedIndex {
        case 0:
            return .sequential
        case 1:
            return .random
        case 2:
            return .reverse
        default:
            return .sequential
        }
    }
}
