//
//  WordListViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import RealmSwift

final class WordListViewModel {
    
    // MARK: - Properties
    private let group: VocabularyGroup
    private let realmManager: RealmManagerProtocol
    
    private(set) var wordList: Results<VocabularyWord>? {
        didSet {
            onWordsUpdated?(wordList)
        }
    }
    
    var onWordsUpdated: ((Results<VocabularyWord>?) -> Void)?
    
    // MARK: - Initializer
    init(group: VocabularyGroup, realmManager: RealmManagerProtocol) {
        self.group = group
        self.realmManager = realmManager
    }
    
    // MARK: - Computed Properties
    var currentGroup: VocabularyGroup {
        group
    }
    
    var title: String {
        group.name
    }
    
    // MARK: - Data Source Methods
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.wordList?.count ?? 0
    }
    
    func memberViewModel(at index: Int) -> WordViewModel {
        let word = self.wordList?[index]
        return WordViewModel(word: word!, realmManager: realmManager)
    }
    
    // 뷰모델 생성
    func wordViewModel(at index: Int) -> AddWordViewModel {
        let word = self.wordList?[index]
        return AddWordViewModel(group: group, realmManager: realmManager, word: word)
    }
    
    // MARK: - Data Management
    func fetchWords() {
        if let updatedGroup = realmManager.fetchObject(VocabularyGroup.self, for: group.id) {
            wordList = updatedGroup.words.sorted(byKeyPath: "createdAt", ascending: false)
        } else {
            wordList = nil
        }
    }
    
    func searchWords(text: String) {
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", text)
        
        if let updatedGroup = realmManager.fetchObject(VocabularyGroup.self, for: group.id) {
            wordList = updatedGroup.words
                .filter(predicate)
                .sorted(byKeyPath: "createdAt", ascending: false)
        } else {
            wordList = nil
        }
    }
    
    func deleteWord(at index: Int) {
        guard let word = wordList?[index] else { return }
        realmManager.deleteObject(word)
        fetchWords()
    }
    
    // MARK: - Navigation
    func navigateToAddWordVC(from viewController: UIViewController, at index: Int? = nil, animated: Bool) {
        let wordVM: AddWordViewModel
        // 기존의 단어가 있을때
        if let index = index {
            wordVM = wordViewModel(at: index)
        // 새로운 단어 생성할때
        } else {
            wordVM = AddWordViewModel(group: group, realmManager: self.realmManager, word: nil)
        }
        let addWordVC = AddWordViewController(viewModel: wordVM)
        viewController.navigationController?.pushViewController(addWordVC, animated: animated)
    }
}
