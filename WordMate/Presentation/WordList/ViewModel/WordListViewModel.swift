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
    
    var words: Results<VocabularyWord>? {
        didSet {
            onWordsUpdated?(words)
        }
    }
    
    var onWordsUpdated: ((Results<VocabularyWord>?) -> Void)?
    
    init(group: VocabularyGroup, realmManager: RealmManagerProtocol) {
        self.group = group
        self.realmManager = realmManager
    }
    
    var title: String {
        return group.name
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.words?.count ?? 0
    }
    
    func memberViewModelAtIndex(_ index: Int) -> WordViewModel {
        let word = self.words?[index]
        return WordViewModel(word: word!)
    }
    
    func fetchWords() {
        // Realm에서 그룹 데이터가 갱신될 경우를 대비하여 최신 데이터를 가져옴
        if let updatedGroup = realmManager.fetchObject(VocabularyGroup.self, for: group.id) {
            words = updatedGroup.words.sorted(byKeyPath: "name", ascending: true)
        } else {
            words = nil
        }
        print("words: \(words?.first?.name)")
        // *그룹 -> 단어장에서 단어가 저장이 안됨
    }
    
    func goToAddWordVC(from viewController: UIViewController, animated: Bool) {
        let addWordVC = AddWordViewController()
        viewController.navigationController?.pushViewController(addWordVC, animated: animated)
    }
}
