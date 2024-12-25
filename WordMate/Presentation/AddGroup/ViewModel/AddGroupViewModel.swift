//
//  AddGroupViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/21/24.
//

import UIKit
import RealmSwift

class AddGroupViewModel {
    private let realmManager: RealmManagerProtocol
    
    private var group: VocabularyGroup?
    private var index: Int?
    
    init(realmManager: RealmManagerProtocol, group: VocabularyGroup? = nil, index: Int? = nil) {
        self.realmManager = realmManager
        self.group = group
        self.index = index
    }
    
    var buttonTitle: String {
        group != nil ? "수정" : "저장"
    }
    
    func handelButtonTapped(name: String) {
        if group != nil {
            updateGroup(newName: name)
        } else {
            makeNewGroup(name: name)
        }
    }
    
    func updateGroup(newName: String) {
        guard let group = group else { return }
        realmManager.updateGroupName(group, to: newName)
    }

    func makeNewGroup(name: String, language: String = "English") {
        let group = VocabularyGroup()
        group.name = name
        group.language = language
        
        realmManager.addObject(group)
        print("Group saved successfully")
    }
    
    func goBackToPreviousVC(from viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popViewController(animated: animated)
    }
}
