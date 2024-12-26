//
//  WordListViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import RealmSwift

class WordListViewModel {
    private let group: VocabularyGroup
    private let realmManager: RealmManagerProtocol
    
    var wordList: Results<VocabularyWord>? {
        didSet {
            onWordsUpdated?(wordList)
        }
    }
    
    var onWordsUpdated: ((Results<VocabularyWord>?) -> Void)?
    
    init(group: VocabularyGroup, realmManager: RealmManagerProtocol) {
        self.group = group
        self.realmManager = realmManager
    }
    
    var currentGroup: VocabularyGroup {
        return group
    }
    
    var title: String {
        return group.name
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.wordList?.count ?? 0
    }
    
    func memberViewModelAtIndex(_ index: Int) -> WordViewModel {
        let word = self.wordList?[index]
        return WordViewModel(word: word!, realmManager: RealmManager())
    }
    
    // 뷰모델 생성
    func wordViewModelAtIndex(_ index: Int) -> AddWordViewModel {
        let word = self.wordList?[index]
        return AddWordViewModel(group: group, realmManager: RealmManager(), word: word, index: index)
    }
    
    func fetchWords() {
        if let updatedGroup = realmManager.fetchObject(VocabularyGroup.self, for: group.id) {
            wordList = updatedGroup.words.sorted(byKeyPath: "createdAt", ascending: false)
        } else {
            wordList = nil
        }
    }
    
    func deleteGroup(at index: Int) {
        guard let word = wordList?[index] else { return }
        realmManager.deleteObject(word)
        fetchWords()
    }
    
    // MARK: - Navigation
    func handleNextVC(at index: Int? = nil, fromCurrentVC: UIViewController, animated: Bool) {
        // 기존의 단어가 있을때
        if let index = index {
            let wordVM = wordViewModelAtIndex(index)
            goToAddWordVC(with: wordVM, from: fromCurrentVC, group: group, animated: animated)
        // 새로운 단어 생성시
        } else {
            let newVM = AddWordViewModel(group: group, realmManager: self.realmManager, word: nil, index: nil)
            goToAddWordVC(with: newVM, from: fromCurrentVC, group: group, animated: animated)
        }
    }
    
    func goToAddWordVC(with wordVM: AddWordViewModel,from viewController: UIViewController, group: VocabularyGroup, animated: Bool) {
        let addWordVC = AddWordViewController(viewModel: wordVM)
        viewController.navigationController?.pushViewController(addWordVC, animated: animated)
    }
}
