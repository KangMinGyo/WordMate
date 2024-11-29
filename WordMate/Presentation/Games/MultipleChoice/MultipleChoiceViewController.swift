//
//  MultipleChoiceViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

class MultipleChoiceViewController: UIViewController {
    
    private let wordLabelView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 20
    }
    
    private let wordLabel = UILabel().then {
        $0.text = "Word"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    private let choice1Button = UIButton().then {
        $0.tintColor = .white
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    private let choice2Button = UIButton().then {
        $0.tintColor = .white
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    private let choice3Button = UIButton().then {
        $0.tintColor = .white
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    private let choice4Button = UIButton().then {
        $0.tintColor = .white
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        choice1Button, choice2Button, choice3Button, choice4Button]).then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fillEqually
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupButtons()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupButtons() {
        // 버튼 공통 설정
        let buttons = [choice1Button, choice2Button, choice3Button, choice4Button]
        
        for (index, button) in buttons.enumerated() {
            button.setTitle("Choice \(index + 1)", for: .normal)
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            button.tag = index
        }
    }
    
    @objc private func handleButtonTap(_ sender: UIButton) {
        let selectedIndex = sender.tag
        print("Selected choice: \(selectedIndex + 1)")
    }
        
    private func setupSubviews() {
        view.addSubview(wordLabelView)
        wordLabelView.addSubview(wordLabel)
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        wordLabelView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(400)
        }
        
        wordLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(wordLabelView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
    }
}
