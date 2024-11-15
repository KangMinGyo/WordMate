//
//  SettringViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/13/24.
//

import UIKit

class SettingsViewController: UIViewController {

    private let settingLabel = UILabel().then {
        $0.text = "설정"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(settingLabel)
    }

    private func setupConstraints() {
        settingLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
