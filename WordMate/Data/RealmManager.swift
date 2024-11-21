//
//  RealmManager.swift
//  WordMate
//
//  Created by KangMingyo on 11/21/24.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    let realm = try! Realm()
    
    func add<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Failed to add: \(error.localizedDescription)")
        }
    }
}
