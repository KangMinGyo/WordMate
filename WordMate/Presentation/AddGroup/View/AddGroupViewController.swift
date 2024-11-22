//
//  AddGroupViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/15/24.
//

import UIKit
import Then
import SnapKit

class AddGroupViewController: UIViewController {
    
    private let groupLabel = UILabel().then {
        $0.text = "그룹 이름"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    private lazy var groupTextField = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let viewModel = AddGroupViewModel(realmManager: RealmManager())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupNaviBar()
        setupSubviews()
        setupConstraints()
    }
    
    func setupNaviBar() {
        title = "그룹"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc func saveButtonTapped() {
        guard let name = groupTextField.text else { return }
        viewModel.makeNewGroup(name: name)
        viewModel.goBackToPreviousVC(from: self, animated: true)
    }
    
    private func setupSubviews() {
        view.addSubview(groupLabel)
        view.addSubview(groupTextField)
    }

    private func setupConstraints() {
        groupLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        groupTextField.snp.makeConstraints {
            $0.top.equalTo(groupLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
    }
}
