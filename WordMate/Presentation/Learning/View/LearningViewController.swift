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
    
    //MARK: - ViewModel
    let viewModel: LearningViewModel
    
    
    // MARK: - Initializers
    init(viewModel: LearningViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "학습"
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        addTarget()
    }
    
    @objc func flashButtonTapped() {
        viewModel.goToGameSettingVC(from: self, title: "플래시카드")
    }
    
    @objc func choicesButtonTapped() {
        viewModel.goToGameSettingVC(from: self, title: "사지선다")
    }
    
    @objc func dictationButtonTapped() {
        viewModel.goToGameSettingVC(from: self, title: "받아쓰기")
    }
    
    @objc func loopButtonTapped() {
        viewModel.goToGameSettingVC(from: self, title: "반복하기")
    }
    
    private func addTarget() {
        flashCardButton.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
        choicesButton.addTarget(self, action: #selector(choicesButtonTapped), for: .touchUpInside)
        dictationButton.addTarget(self, action: #selector(dictationButtonTapped), for: .touchUpInside)
        loopButton.addTarget(self, action: #selector(loopButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(buttonHeight * 4)
        }
    }
}
