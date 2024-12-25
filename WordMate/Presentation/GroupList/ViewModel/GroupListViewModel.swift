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
    
    var groupList: Results<VocabularyGroup>? {
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
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.groupList?.count ?? 0
    }
    
    // 뷰모델 생성
    func groupViewModelAtIndex(_ index: Int) -> AddGroupViewModel {
        let group = self.groupList?[index]
        return AddGroupViewModel(realmManager: RealmManager(), group: group, index: index)
    }
    
    func fetchGroups() {
        groupList = realmManager.fetchObjects(VocabularyGroup.self)
    }
    
    func deleteGroup(at index: Int) {
        guard let group = groupList?[index] else { return }
        realmManager.deleteObject(group)
        fetchGroups()
    }

    // MARK: - Navigation
    func handleNextVC(at index: Int? = nil, fromCurrentVC: UIViewController, animated: Bool) {
        // 기존의 그룹이 있을때
        if let index = index {
            let groupVM = groupViewModelAtIndex(index)
            goToAddGroupVC(with: groupVM, from: fromCurrentVC, animated: animated)
        // 새로운 그룹 생성시
        } else {
            let newVM = AddGroupViewModel(realmManager: self.realmManager, group: nil, index: nil)
            goToAddGroupVC(with: newVM, from: fromCurrentVC, animated: animated)
        }
    }
    
    func goToAddGroupVC(with groupVM: AddGroupViewModel,from viewController: UIViewController, animated: Bool) {
        let addGroupVC = AddGroupViewController(viewModel: groupVM)
        viewController.navigationController?.pushViewController(addGroupVC, animated: animated)
    }
    
    func goToWordListVC(from viewController: UIViewController, group: VocabularyGroup, animated: Bool) {
        let wordListViewModel = WordListViewModel(group: group, realmManager: RealmManager())
        let wordListVC = WordListViewController(viewModel: wordListViewModel)
        viewController.navigationController?.pushViewController(wordListVC, animated: animated)
    }
}
