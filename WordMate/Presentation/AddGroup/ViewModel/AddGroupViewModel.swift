//
//  AddGroupViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/21/24.
//

import UIKit
import RealmSwift

class AddGroupViewModel {
    let realm = try! Realm()

    func makeNewGroup(name: String) {
        let group = VocabularyGroup()
        group.name = name
        group.language = "English"
        
        do {
            try realm.write {
                realm.add(group)
            }
            print("Group saved successfully")
        } catch {
            print("Error saving group: \(error)")
        }
    }
    
    func goBackToPreviousVC(from viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popViewController(animated: animated)
    }
}
