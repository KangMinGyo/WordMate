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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(textFieldHeight * 4)
        }
    }
    
}
