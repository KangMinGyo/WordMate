//
//  QuestionSelectionViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/4/24.
//

import Foundation

final class QuestionSelectionViewModel {
    
    // MARK: - Properties
    private var options = ["모든 단어", "즐겨찾기한 단어"]
    private var selectedIndex: Int?
    
    var onQuestionSelected: ((Bool?) -> Void)?
    
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
    
    func currentSelection() -> Bool? {
        // 선택 상태 반환: 0 -> false, 1 -> true, nil -> 선택 없음
        guard let selectedIndex = selectedIndex else { return nil }
        return selectedIndex == 1
    }
}
