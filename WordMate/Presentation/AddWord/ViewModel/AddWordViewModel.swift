//
//  AddWordViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/20/24.
//

import UIKit

class AddWordViewModel {
    private let group: VocabularyGroup
    private let realmManager: RealmManagerProtocol
    
    init(group: VocabularyGroup, realmManager: RealmManagerProtocol) {
        self.group = group
        self.realmManager = realmManager
    }
    
    var currentGroup: VocabularyGroup {
        return group
    }
    
    func makeNewWord(name: String, pronunciation: String?, meaning: String, descriptionText: String?, isLiked: Bool) {
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
