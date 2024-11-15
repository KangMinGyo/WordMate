//
//  LearningViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/13/24.
//

import UIKit
import Then
import SnapKit

class LearningViewController: UIViewController {
    
    private let learningLabel = UILabel().then {
        $0.text = "학습"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private lazy var game1Button = UIButton().then {
        $0.setTitle("플래시카드", for: .normal)
        $0.backgroundColor = .systemGray3
        $0.layer.shadowColor = UIColor.systemGray.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.cornerRadius = 25
    }
    
    private lazy var game2Button = UIButton().then {
        $0.setTitle("사지선다", for: .normal)
        $0.backgroundColor = .systemGray3
        $0.layer.shadowColor = UIColor.systemGray.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.cornerRadius = 25
    }
    
    private lazy var game3Button = UIButton().then {
        $0.setTitle("받아쓰기", for: .normal)
        $0.backgroundColor = .systemGray3
        $0.layer.shadowColor = UIColor.systemGray.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.cornerRadius = 25
    }
    
    private lazy var game4Button = UIButton().then {
        $0.setTitle("깜빡이", for: .normal)
        $0.backgroundColor = .systemGray3
        $0.layer.shadowColor = UIColor.systemGray.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.cornerRadius = 25
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        game1Button, game2Button, game3Button, game4Button]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private let buttonHeight: CGFloat = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(learningLabel)
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        learningLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(learningLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(buttonHeight * 4)
        }
    }

}
