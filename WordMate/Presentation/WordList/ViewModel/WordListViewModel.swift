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
    
    var currentGroup: VocabularyGroup {
        return group
    }
    
    var title: String {
        return group.name
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.words?.count ?? 0
    }
    
    func memberViewModelAtIndex(_ index: Int) -> WordViewModel {
        let word = self.words?[index]
        return WordViewModel(word: word!, realmManager: RealmManager())
    }
    
    func fetchWords() {
        // Realm에서 그룹 데이터가 갱신될 경우를 대비하여 최신 데이터를 가져옴
        if let updatedGroup = realmManager.fetchObject(VocabularyGroup.self, for: group.id) {
            words = updatedGroup.words.sorted(byKeyPath: "createdAt", ascending: false)
        } else {
            words = nil
        }
    }
    
    func goToAddWordVC(from viewController: UIViewController, group: VocabularyGroup, animated: Bool) {
        let addWordVC = AddWordViewController(group: group, realmManager: RealmManager())
        viewController.navigationController?.pushViewController(addWordVC, animated: animated)
    }
}
