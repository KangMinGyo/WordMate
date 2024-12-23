//
//  AddWordViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import Then
import SnapKit

class AddWordViewController: UIViewController {
    
    private let viewModel: AddWordViewModel
    
    private lazy var wordTextField = UITextField().then {
        $0.placeholder = "단어"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var meaningTextField = UITextField().then {
        $0.placeholder = "뜻"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var pronunciationTextField = UITextField().then {
        $0.placeholder = "발음(선택)"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var descriptionTextField = UITextField().then {
        $0.placeholder = "설명(선택)"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        wordTextField, meaningTextField, pronunciationTextField, descriptionTextField]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private let textFieldHeight: CGFloat = 60
    
    init(group: VocabularyGroup, realmManager: RealmManagerProtocol) {
        self.viewModel = AddWordViewModel(group: group, realmManager: realmManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        wordTextField.delegate = self
        meaningTextField.delegate = self
        setupNaviBar()
        setupSubviews()
        setupConstraints()
    }
    
    func setupNaviBar() {
        title = "단어"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func saveButtonTapped() {
        guard let name = wordTextField.text else { return }
        let pronunciation = pronunciationTextField.text ?? nil
        guard let meaning = meaningTextField.text else { return }
        let description = descriptionTextField.text ?? nil
        
        viewModel.makeNewWord(name: name, pronunciation: pronunciation, meaning: meaning, descriptionText: description, isLiked: false)
        
        resetTextField()
    }
    
    private func resetTextField() {
        wordTextField.text = ""
        pronunciationTextField.text = ""
        meaningTextField.text = ""
        descriptionTextField.text = ""
        updateSaveButtonState(isWordValid: false, isMeaningValid: false)
    }
    
    private func setupSubviews() {
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(textFieldHeight * 4)
        }
    }
    
    private func updateSaveButtonState(isWordValid: Bool, isMeaningValid: Bool) {
        let saveButton = navigationItem.rightBarButtonItem
        saveButton?.isEnabled = isWordValid && isMeaningValid
        saveButton?.tintColor = (isWordValid && isMeaningValid) ? .primaryOrange : .lightGray
    }
}

extension AddWordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        DispatchQueue.main.async {
            if textField == self.wordTextField {
                let isWordValid = !updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isMeaningValid = !(self.meaningTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.updateSaveButtonState(isWordValid: isWordValid, isMeaningValid: isMeaningValid)
            } else if textField == self.meaningTextField {
                let isWordValid = !(self.wordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isMeaningValid = !updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.updateSaveButtonState(isWordValid: isWordValid, isMeaningValid: isMeaningValid)
            }
        }
        return true
    }
}
