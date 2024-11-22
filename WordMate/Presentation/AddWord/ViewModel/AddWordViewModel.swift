//
//  AddWordViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/20/24.
//

import UIKit

class AddWordViewModel {
    private let realmManager: RealmManagerProtocol
    
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }
    
    func makeNewWord(group: VocabularyGroup, name: String, pronunciation: String?, meaning: String, descriptionText: String?, isLiked: Bool) {
        let word = VocabularyWord()
        word.name = name
        word.pronunciation = pronunciation
        word.meaning = meaning
        word.descriptionText = descriptionText
        word.isLiked = false
        
        realmManager.addWordToGroup(group, word: word)
    }

    func goBackToPreviousVC(from viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popViewController(animated: animated)
    }
}
