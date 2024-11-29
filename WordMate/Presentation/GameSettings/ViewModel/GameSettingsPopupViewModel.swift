//
//  GameSettingsPopupViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

class GameSettingsPopupViewModel {

    func MultipleChoiceVC(from viewController: UIViewController, animated: Bool) {
        let multipleChoiceVC = MultipleChoiceViewController()
        multipleChoiceVC.modalPresentationStyle = .overFullScreen
        viewController.present(multipleChoiceVC, animated: animated, completion: nil)
    }
}
