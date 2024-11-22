//
//  GroupListViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import RealmSwift

class GroupListViewModel {
    
    var groups: Results<VocabularyGroup>? {
        didSet {
            onGroupsUpdated?(groups)
        }
    }
    
    var onGroupsUpdated: ((Results<VocabularyGroup>?) -> Void)?
    
    func fetchGroups() {
        let realm = try! Realm()
        groups = realm.objects(VocabularyGroup.self)
    }

    func goToAddGroupVC(from viewController: UIViewController, animated: Bool) {
        let addGroupVC = AddGroupViewController()
        viewController.navigationController?.pushViewController(addGroupVC, animated: animated)
    }
    
    func goToWordListVC(from viewController: UIViewController, animated: Bool) {
        let wordListVC = WordListViewController(viewModel: WordListViewModel())
        viewController.navigationController?.pushViewController(wordListVC, animated: animated)
    }
}
