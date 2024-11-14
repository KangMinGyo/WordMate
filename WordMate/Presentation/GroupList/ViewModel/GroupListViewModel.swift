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
    
    func handleNextVC(from viewController: UIViewController, animated: Bool) {
        goToNextVC(from: viewController, animated: animated)
    }
    
    private func goToNextVC(from viewController: UIViewController, animated: Bool) {
                
        let navVC = viewController.navigationController
        
        let wordListVC = WordListViewController()
        navVC?.pushViewController(wordListVC, animated: animated)
    }
}
