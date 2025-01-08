//
//  AddGroupViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/15/24.
//

import UIKit
import Then
import SnapKit

final class AddGroupViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: AddGroupViewModel
    
    private let groupLabel = UILabel().then {
        $0.text = "그룹 이름"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    private lazy var groupTextField = UITextField().then {
        $0.borderStyle = .none
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addPadding()
    }
    
    // MARK: - Initializer
    
    init(viewModel: AddGroupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        groupTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupNaviBar()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupNaviBar() {
        title = "그룹"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.buttonTitle, 
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveButtonTapped))
        navigationController?.navigationBar.tintColor = .black
        updateSaveButtonState(isEnabled: false)
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
    
    // MARK: - Actions
    
    @objc func saveButtonTapped() {
        guard let name = groupTextField.text else { return }
        
        if viewModel.isDuplicateGroup(name: name) {
            showAlert(title: "중복된 그룹", message: "이미 존재하는 그룹입니다.")
            return
        }
        
        viewModel.handleButtonTapped(name: name)
        viewModel.goBackToPreviousVC(from: self, animated: true)
    }
    
    private func updateSaveButtonState(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        navigationItem.rightBarButtonItem?.tintColor = isEnabled ? .primaryOrange : .lightGray
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension AddGroupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        DispatchQueue.main.async {
            let isTextValid = !updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            self.updateSaveButtonState(isEnabled: isTextValid)
        }
        return true
    }
}
