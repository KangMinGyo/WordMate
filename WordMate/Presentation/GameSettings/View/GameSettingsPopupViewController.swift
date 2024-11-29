//
//  GameSettingsPopupViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/28/24.
//

import UIKit

class GameSettingsPopupViewController: UIViewController {
    
    private let popupView: GameSettingsPopupView
    
    //MARK: - ViewModel
    let viewModel: GameSettingsPopupViewModel
    
    
    // MARK: - Initializers
    init(viewModel: GameSettingsPopupViewModel, title: String) {
        self.viewModel = viewModel
        self.popupView = GameSettingsPopupView(title: title)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        popupView.cancelAction = { [weak self] in
            self?.handleCancel()
        }
        
        popupView.startAction = { [weak self] in
            self?.handleStart()
        }
        
        view.addSubview(popupView)
    }

    private func setupConstraints() {
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func handleStart() {
        print("start")
        guard let pvc = self.presentingViewController else { return }
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.viewModel.MultipleChoiceVC(from: pvc, animated: true)
        }
    }
}
