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
    
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }

    func makeNewGroup(name: String) {
        let group = VocabularyGroup()
        group.name = name
        group.language = "English"
        
        realmManager.addObject(group)
        print("Group saved successfully")
    }
    
    func goBackToPreviousVC(from viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popViewController(animated: animated)
    }
}
