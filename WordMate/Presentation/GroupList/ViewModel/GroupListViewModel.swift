//
//  GroupListViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit

class GroupListViewModel {
    
    // 데이터 배열
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    func goToWordListVC(from viewController: UIViewController, animated: Bool) {
        let wordListVC = WordListViewController(viewModel: WordListViewModel())
        viewController.navigationController?.pushViewController(wordListVC, animated: animated)
    }
}
