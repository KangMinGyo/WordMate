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
    
    func fetchWords() {
        // Realm에서 그룹 데이터가 갱신될 경우를 대비하여 최신 데이터를 가져옴
        if let updatedGroup = realmManager.fetchObject(VocabularyGroup.self, for: group.id) {
            words = updatedGroup.words.sorted(byKeyPath: "name", ascending: true)
        } else {
            words = nil
        }
    }
    
    func goToAddWordVC(from viewController: UIViewController, animated: Bool) {
        let addWordVC = AddWordViewController()
        viewController.navigationController?.pushViewController(addWordVC, animated: animated)
    }
}
