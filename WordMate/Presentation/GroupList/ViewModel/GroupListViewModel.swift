//
//  GroupListViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import RealmSwift

final class GroupListViewModel {
    
    // MARK: - Properties
    
    private let realmManager: RealmManagerProtocol
    
    private(set) var groupList: Results<VocabularyGroup>? {
        didSet {
            onGroupsUpdated?(groupList)
        }
    }
    
    var onGroupsUpdated: ((Results<VocabularyGroup>?) -> Void)?
    
    // MARK: - Initializer
    
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }
    
    // MARK: - Data Handling
    
    func fetchGroups() {
        groupList = realmManager.fetchObject(VocabularyGroup.self)
    }
    
    func searchGroups(text: String) {
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", text)
        groupList = realmManager.fetchObject(VocabularyGroup.self).filter(predicate)
    }
    
    func deleteGroup(at index: Int) {
        guard let group = groupList?[index] else { return }
        realmManager.deleteObject(group)
        fetchGroups()
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.groupList?.count ?? 0
    }
    
    func groupViewModel(at index: Int) -> AddGroupViewModel? {
        guard let group = self.groupList?[index] else { return nil }
        return AddGroupViewModel(realmManager: realmManager, group: group, index: index)
    }

    // MARK: - Navigation
    
    func navigateToAddGroupVC(from viewController: UIViewController, at index: Int? = nil, animated: Bool) {
        let addGroupViewModel: AddGroupViewModel
        // 기존의 그룹이 있을때(수정)
        if let index = index, let groupVM = groupViewModel(at: index) {
            addGroupViewModel = groupVM
        // 새로운 그룹 생성할때
        } else {
            addGroupViewModel = AddGroupViewModel(realmManager: realmManager, group: nil, index: nil)
        }
        
        let addGroupVC = AddGroupViewController(viewModel: addGroupViewModel)
        viewController.navigationController?.pushViewController(addGroupVC, animated: animated)
    }

    func navigateToWordListVC(from viewController: UIViewController, group: VocabularyGroup, animated: Bool) {
        let wordListViewModel = WordListViewModel(group: group, realmManager: RealmManager())
        let wordListVC = WordListViewController(viewModel: wordListViewModel)
        viewController.navigationController?.pushViewController(wordListVC, animated: animated)
    }
}
