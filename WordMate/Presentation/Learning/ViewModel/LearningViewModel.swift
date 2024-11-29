//
//  LearningViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

class LearningViewModel {
    func goToGameSettingVC(from viewController: UIViewController, title: String) {
        let popupViewController = GameSettingsPopupViewController(title: title)
        popupViewController.modalPresentationStyle = .overFullScreen
        viewController.present(popupViewController, animated: false)
    }
}
