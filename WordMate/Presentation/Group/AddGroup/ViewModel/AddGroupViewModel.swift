//
//  AddGroupViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/21/24.
//

import UIKit
import RealmSwift

final class AddGroupViewModel {
    
    // MARK: - Properties
    private let realm = try! Realm()
    private let realmManager: RealmManagerProtocol
    private var group: VocabularyGroup?
    private var index: Int?
    
    // MARK: - Initializer
    init(realmManager: RealmManagerProtocol, group: VocabularyGroup? = nil, index: Int? = nil) {
        self.realmManager = realmManager
        self.group = group
        self.index = index
    }
    
    // MARK: - Computed Properties
    var buttonTitle: String {
        group != nil ? "수정" : "저장"
    }
    
    // MARK: - Group Management
    func handleButtonTapped(name: String) {
        group != nil ? updateGroup(newName: name) : createNewGroup(name: name)
    }
    
    func isDuplicateGroup(name: String) -> Bool {
        return realm.isGroupExisting(name: name)
    }
    
    private func updateGroup(newName: String) {
        guard let group = group else { return }
        realmManager.updateObject(group) { $0.name = newName }
    }
    
    private func createNewGroup(name: String, language: String = "English") {
        let group = VocabularyGroup(name: name, language: language)
        realmManager.addObject(group) { _ in
            print("그룹 저장 완료")
        }
    }
    
    // MARK: - Navigation
    func goBackToPreviousVC(from viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popViewController(animated: animated)
    }
}
