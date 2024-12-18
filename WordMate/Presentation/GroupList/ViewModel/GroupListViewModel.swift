//
//  GroupListViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import RealmSwift

class GroupListViewModel {
    // MARK: - Properties
    private let realmManager: RealmManagerProtocol
    
    var groups: Results<VocabularyGroup>? {
        didSet {
            onGroupsUpdated?(groups)
        }
    }
    
    var onGroupsUpdated: ((Results<VocabularyGroup>?) -> Void)?
    
    // MARK: - Initializer
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }
    
    // MARK: - Data Handling
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.groups?.count ?? 0
    }
    
    func fetchGroups() {
        groups = realmManager.fetchObjects(VocabularyGroup.self)
    }

    // MARK: - Navigation
    func goToAddGroupVC(from viewController: UIViewController, animated: Bool) {
        let addGroupVC = AddGroupViewController()
        viewController.navigationController?.pushViewController(addGroupVC, animated: animated)
    }
    
    func goToWordListVC(from viewController: UIViewController, group: VocabularyGroup, animated: Bool) {
        let wordListViewModel = WordListViewModel(group: group, realmManager: RealmManager())
        let wordListVC = WordListViewController(viewModel: wordListViewModel)
        viewController.navigationController?.pushViewController(wordListVC, animated: animated)
    }
}
