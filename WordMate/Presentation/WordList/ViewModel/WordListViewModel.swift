//
//  WordListViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit

class WordListViewModel {
    
    func goToAddWordVC(from viewController: UIViewController, animated: Bool) {
        let addWordVC = AddWordViewController()
        viewController.navigationController?.pushViewController(addWordVC, animated: animated)
    }
}
