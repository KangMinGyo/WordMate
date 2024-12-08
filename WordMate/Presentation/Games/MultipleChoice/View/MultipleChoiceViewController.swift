//
//  MultipleChoiceViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

class MultipleChoiceViewController: UIViewController {
    
    let viewModel: MultipleChoiceViewModel
    let speechService = SpeechService()
    private var options: [MultipleChoiceOption] = []
    
    private let gameStatusView = GameStatusView()
    
    private let wordLabelView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 20
    }
    
    private let wordLabel = UILabel().then {
        $0.text = "Word"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    private lazy var speakerButton = UIButton().then {
        $0.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray  // 아이콘 색상 변경
        $0.addTarget(self, action: #selector(speakerButtonTapped), for: .touchUpInside)
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
    
    private lazy var optionButtons: [UIButton] = [
        choice1Button,
        choice2Button,
        choice3Button,
        choice4Button
    ]
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        choice1Button, choice2Button, choice3Button, choice4Button]).then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fillEqually
        }

    private let skipButton = UIButton().then {
        $0.setTitle("잘 모르겠어요", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.setTitleColor(.gray, for: .normal)
    }
    
    // MARK: - Initializers
    init(viewModel: MultipleChoiceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupButtons()
        setupSubviews()
        setupConstraints()
        wordSetting()
        setupOptions()
        gameStatusView.indicatorLabel.text = "\(viewModel.currentIndex) / \(viewModel.totalWords)"
    }
    
    private func setupButtons() {
        let buttons = [choice1Button, choice2Button, choice3Button, choice4Button]
        
        for (index, button) in buttons.enumerated() {
            button.setTitle("Choice \(index + 1)", for: .normal)
            button.addTarget(self, action: #selector(choiceButtonTapped(_:)), for: .touchUpInside)
            button.tag = index
        }
        
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func speakerButtonTapped() {
        guard let text = wordLabel.text else { return }
        speechService.speak(text)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func wordSetting() {
        wordLabel.text = viewModel.currentWord.name
    }
    
    private func setupOptions() {
        options = viewModel.generateOptions()
        
        for (index, button) in optionButtons.enumerated() {
            guard index < options.count else { return }
            button.setTitle(options[index].meaning, for: .normal)
        }
    }
    
    @objc private func choiceButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let selectedOption = options[index]
        
        if selectedOption.isCorrct {
            print("정답")
        } else {
            print("오답")
        }
    }
        
    private func setupSubviews() {
        view.addSubview(gameStatusView)
        view.addSubview(wordLabelView)
        wordLabelView.addSubview(wordLabel)
        wordLabelView.addSubview(speakerButton)
        view.addSubview(stackView)
        view.addSubview(skipButton)
    }

    private func setupConstraints() {
        gameStatusView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
        
        wordLabelView.snp.makeConstraints {
            $0.top.equalTo(gameStatusView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(300)
        }
        
        wordLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        speakerButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(wordLabelView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
