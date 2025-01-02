//
//  GroupSelectionViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit
import RealmSwift

final class GroupSelectionViewModel {
    
    // MARK: - Properties
    private let realmManager: RealmManagerProtocol
    private(set) var groups: Results<VocabularyGroup>?
    
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
    
    // MARK: - Public Methods
    func numberOfRowsInSection(_ section: Int) -> Int {
        groups?.count ?? 0
    }
    
    func fetchGroups() {
        groups = realmManager.fetchObject(VocabularyGroup.self)
    }
    
    func group(at index: Int) -> VocabularyGroup? {
        guard let groups = groups, index >= 0, index < groups.count else {
            return nil
        }
        return groups[index]
    }
}
