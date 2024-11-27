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
    
    private func customButton(title: String, image: UIImage?) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setImage(image, for: .normal)
            $0.backgroundColor = .systemGray6
            $0.layer.shadowColor = UIColor.systemGray.cgColor
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowRadius = 5
            $0.layer.shadowOffset = CGSize(width: 1, height: 1)
            $0.layer.cornerRadius = 25
        }
    }
    
    private lazy var flashCardButton: UIButton = {
        return customButton(title: "플래시카드", image: .flashCardImage)
    }()
    
    private lazy var choicesButton: UIButton = {
        return customButton(title: "사지선다", image: .gridImage)
    }()
    
    private lazy var dictationButton: UIButton = {
        return customButton(title: "받아쓰기", image: .dictationImage)
    }()
    
    private lazy var loopButton: UIButton = {
        return customButton(title: "반복하기", image: .loopImage)
    }()
    
    private lazy var firstStackView = UIStackView(arrangedSubviews: [
        flashCardButton, choicesButton]).then {
            $0.axis = .horizontal
            $0.spacing = 15
            $0.distribution = .fillEqually
        }
    
    private lazy var secondStackView = UIStackView(arrangedSubviews: [
        dictationButton, loopButton]).then {
            $0.axis = .horizontal
            $0.spacing = 15
            $0.distribution = .fillEqually
        }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        firstStackView, secondStackView]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillEqually
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
