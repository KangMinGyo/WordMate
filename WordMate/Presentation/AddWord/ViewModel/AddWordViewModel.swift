//
//  AddWordViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/20/24.
//

import UIKit
import RealmSwift

final class AddWordViewModel {
    
    // MARK: - Properties
    private let group: VocabularyGroup
    private let realmManager: RealmManagerProtocol
    private var word: VocabularyWord?
    
    // MARK: - Initializer
    init(group: VocabularyGroup, realmManager: RealmManagerProtocol, word: VocabularyWord? = nil) {
        self.group = group
        self.realmManager = realmManager
        self.word = word
    }
    
    // MARK: - Computed Properties
    var currentGroup: VocabularyGroup { group }
        var name: String { word?.name ?? "" }
        var meaning: String { word?.meaning ?? "" }
        var pronunciation: String { word?.pronunciation ?? "" }
        var description: String { word?.descriptionText ?? "" }
        var buttonTitle: String { word != nil ? "수정" : "저장" }
    
    
    // MARK: - Word Management
    func handleButtonTapped(name: String, pronunciation: String?, meaning: String, descriptionText: String?) {
        word != nil
            ? updateWord(name: name, pronunciation: pronunciation, meaning: meaning, descriptionText: descriptionText)
            : makeNewWord(name: name, pronunciation: pronunciation, meaning: meaning, descriptionText: descriptionText)
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
    
    // 단어 중복 확인
    func isDuplicateWord(name: String, meaning: String) -> Bool {
        return realmManager.isWordExisting(name: name, meaning: meaning)
    }

    // MARK: - Navigation
    func goBackToPreviousVC(from viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popViewController(animated: animated)
    }
}
