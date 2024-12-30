//
//  LearningViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/13/24.
//

import UIKit
import Then
import SnapKit

final class LearningViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel: LearningViewModel
    
    // MARK: - Constants
    private let buttonHeight: CGFloat = 100
    
    // MARK: - UI Components
    private lazy var flashCardButton = createButton(
        title: "플래시카드",
        subtitle: "카드를 넘기면서 외워보세요!",
        image: UIImage(systemName: "square.stack"),
        tag: 0
    )
    
    private lazy var choicesButton = createButton(
        title: "사지선다",
        subtitle: "보기에서 정답을 골라보세요!",
        image: UIImage(systemName: "square.grid.2x2"), 
        tag: 1
    )
    
    private lazy var dictationButton = createButton(
        title: "받아쓰기",
        subtitle: "단어의 철자를 받아써보세요!",
        image: UIImage(systemName: "square.and.pencil"),
        tag: 2
    )
    
    private lazy var repeatButton = createButton(
        title: "반복하기",
        subtitle: "반복하며 단어를 외워보세요!",
        image: UIImage(systemName: "repeat"),
        tag: 3
    )

    private lazy var stackView = UIStackView(arrangedSubviews: [
        flashCardButton, choicesButton, dictationButton, repeatButton]).then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    
    // MARK: - Initializers
    init(viewModel: LearningViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        title = "학습"
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        addButtonTargets()
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
    
    // MARK: - Button Configuration
    private func createButton(title: String, subtitle: String, image: UIImage?, tag: Int) -> UIButton {
        let button = CustomButton(title: title, subtitle: subtitle, image: image)
        button.tag = tag
        return button
    }

    private func addButtonTargets() {
        [flashCardButton, choicesButton, dictationButton, repeatButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let titles = ["플래시카드", "사지선다", "받아쓰기", "반복하기"]
        guard sender.tag < titles.count else { return }
        viewModel.goToGameSettingVC(from: self, title: titles[sender.tag])
    }
}
