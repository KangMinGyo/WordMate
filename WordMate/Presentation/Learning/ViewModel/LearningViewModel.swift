//
//  LearningViewModel.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

class LearningViewModel {
    func goToGameSettingVC(from viewController: UIViewController, title: String) {
        let popupVC = GameSettingsPopupViewController(viewModel: GameSettingsPopupViewModel(titleLabelText: title))
        popupVC.modalPresentationStyle = .overFullScreen
        viewController.present(popupVC, animated: false)
    }
}
