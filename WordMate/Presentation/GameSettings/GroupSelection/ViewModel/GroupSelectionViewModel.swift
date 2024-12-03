//
//  GroupSelectionViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import Foundation
import RealmSwift

class GroupSelectionViewModel {
    // MARK: - Properties
    private let realmManager: RealmManagerProtocol
    
    var groups: Results<VocabularyGroup>?
    
    var selectedGroup: VocabularyGroup? {
        didSet {
            onGroupSelected?(selectedGroup)
        }
    }
    var onGroupSelected: ((VocabularyGroup?) -> Void)?
    
    // MARK: - Initializer
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.groups?.count ?? 0
    }
    
    func fetchGroups() {
        groups = realmManager.fetchObjects(VocabularyGroup.self)
    }
}
