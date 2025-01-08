//
//  WordViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/22/24.
//

import UIKit
import RealmSwift

final class WordViewModel {
    
    // MARK: - Properties
    private let word: VocabularyWord
    private let realmManager: RealmManagerProtocol
    
    // MARK: - Initializer
    init(word: VocabularyWord, realmManager: RealmManagerProtocol) {
        self.word = word
        self.realmManager = realmManager
    }
    
    // MARK: - Computed Properties
    var name: String {
        word.name
    }
    
    var pronunciation: String {
        word.pronunciation ?? ""
    }
    
    var meaning: String {
        word.meaning
    }
    
    var descriptionText: String {
        word.descriptionText ?? ""
    }
    
    var isLiked: Bool {
        word.isLiked
    }
    
    // MARK: - Methods
    func updateIsLiked() {
        let newIsLiked = !isLiked
        realmManager.updateObject(word) { $0.isLiked = newIsLiked }
    }
}
