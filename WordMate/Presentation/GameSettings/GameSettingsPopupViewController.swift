//
//  GameSettingsPopupViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/28/24.
//

import UIKit

class GameSettingsPopupViewController: UIViewController {
    
    private let popupView: GameSettingsPopupView
    
    init(title: String) {
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
        view.addSubview(popupView)
    }

    private func setupConstraints() {
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
