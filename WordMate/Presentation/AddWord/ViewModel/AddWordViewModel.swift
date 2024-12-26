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
    private var word: VocabularyWord?
    private var index: Int?
    
    init(group: VocabularyGroup, realmManager: RealmManagerProtocol, word: VocabularyWord? = nil, index: Int? = nil) {
        self.group = group
        self.realmManager = realmManager
        self.word = word
        self.index = index
    }
    
    var currentGroup: VocabularyGroup {
        return group
    }
    
    var name: String {
        return word?.name ?? ""
    }
    
    var meaning: String {
        return word?.meaning ?? ""
    }
    
    var pronunciation: String {
        return word?.pronunciation ?? ""
    }
    
    var description: String {
        return word?.descriptionText ?? ""
    }
    
    var buttonTitle: String {
        word != nil ? "수정" : "저장"
    }
    
    func handelButtonTapped(name: String, pronunciation: String?, meaning: String, descriptionText: String?) {
        if word != nil {
            updateWord(name: name, pronunciation: pronunciation, meaning: meaning, descriptionText: descriptionText)
        } else {
            makeNewWord(name: name, pronunciation: pronunciation, meaning: meaning, descriptionText: descriptionText)
        }
    }
    
    private func updateWord(name: String, pronunciation: String?, meaning: String, descriptionText: String?) {
        guard let word = word else { return }
        realmManager.updateWord(word, name: name, meaning: meaning, pronunciation: pronunciation, descriptionText: descriptionText)
    }
    
    private func makeNewWord(name: String, pronunciation: String?, meaning: String, descriptionText: String?) {
        let word = VocabularyWord()
        word.name = name
        word.pronunciation = pronunciation
        word.meaning = meaning
        word.descriptionText = descriptionText
        word.isLiked = false
        
        realmManager.addWordToGroup(group, word: word)
    }
    
    func isDuplicateWord(name: String, meaning: String) -> Bool {
        return realmManager.isWordExisting(name: name, meaning: meaning)
    }

    func goBackToPreviousVC(from viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popViewController(animated: animated)
    }
}
