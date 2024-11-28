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
    
    private func customButton(title: String, subtitle: String, image: UIImage?) -> UIButton {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = title
        config.subtitle = subtitle
        config.image = image
        config.imagePadding = 10
        config.baseForegroundColor = .primaryOrange
        config.baseBackgroundColor = .systemGray6
        config.cornerStyle = .medium
        
        button.configuration = config
        
        button.layer.shadowColor = UIColor.systemGray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        return button
    }
    
    private lazy var flashCardButton = customButton(
        title: "플래시카드",
        subtitle: "카드를 넘기면서 외워보세요!",
        image: UIImage(systemName: "square.stack")
    )
    
    private lazy var choicesButton = customButton(
        title: "사지선다",
        subtitle: "보기에서 정답을 골라보세요!",
        image: UIImage(systemName: "square.grid.2x2")
    )
    
    private lazy var dictationButton = customButton(
        title: "받아쓰기",
        subtitle: "단어의 철자를 받아써보세요!",
        image: UIImage(systemName: "square.and.pencil")
    )
    
    private lazy var loopButton = customButton(
        title: "반복하기",
        subtitle: "반복하며 단어를 외워보세요!",
        image: UIImage(systemName: "repeat")
    )

    private lazy var stackView = UIStackView(arrangedSubviews: [
        flashCardButton, choicesButton, dictationButton, loopButton]).then {
            $0.axis = .vertical
            $0.spacing = 20
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
