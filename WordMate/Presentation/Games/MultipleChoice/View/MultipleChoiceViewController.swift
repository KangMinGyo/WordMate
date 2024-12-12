//
//  MultipleChoiceViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/29/24.
//

import UIKit

final class MultipleChoiceViewController: UIViewController {
    
    let viewModel: MultipleChoiceViewModel
    let speechService = SpeechService()
    private var options: [MultipleChoiceOption] = []
    
    private let gameStatusView = GameStatusView()
    
    private let wordLabelView = WordLabelView()
    
    private let choice1Button = UIButton().then {
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    private let choice2Button = UIButton().then {
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    private let choice3Button = UIButton().then {
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    private let choice4Button = UIButton().then {
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
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
        setupGame()
    }
    
    private func setupGame() {
        setupIndicator()
        setupWord()
        setupOptions()
    }
    
    private func setupIndicator() {
        gameStatusView.indicatorLabel.text = "\(viewModel.currentIndex + 1) / \(viewModel.totalWords)"
        gameStatusView.progressBar.progress = Float(viewModel.currentIndex + 1) / Float(viewModel.totalWords)
    }
    
    private func setupButtons() {
        let buttons = [choice1Button, choice2Button, choice3Button, choice4Button]
        
        for (index, button) in buttons.enumerated() {
            button.addTarget(self, action: #selector(choiceButtonTapped(_:)), for: .touchUpInside)
            button.tag = index
        }
        
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func speakerButtonTapped() {
        guard let text = wordLabelView.wordLabel.text else { return }
        speechService.speak(text)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupWord() {
        wordLabelView.wordLabel.text = viewModel.currentWord.name
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
        guard let answer = sender.titleLabel?.text else { return }
        
        goToNextWord(isCorrect: selectedOption.isCorrect, userAnswer: answer)
    }
    
    private func goToNextWord(isCorrect: Bool, userAnswer: String) {
        let feedbackMessage = isCorrect ? "정답 🎉" : "오답 💪"
        let feedbackColor: UIColor = isCorrect ? .systemGreen : .systemRed
        wordLabelView.feedbackLabel.isHidden = false
        wordLabelView.feedbackLabel.text = feedbackMessage
        wordLabelView.feedbackLabel.textColor = feedbackColor
        
        viewModel.appendUserResponse(isCorrect: isCorrect, userAnswer: userAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.wordLabelView.feedbackLabel.isHidden = true
            self.viewModel.currentIndex += 1
            
            // 게임 종료 여부 확인 후 진행
            if self.viewModel.currentIndex >= self.viewModel.totalWords {
                self.viewModel.printUserResponses()
                self.viewModel.goToGameResultVC(from: self, animated: true)
            } else {
                self.setupGame()
            }
        }
    }
        
    private func setupSubviews() {
        view.addSubview(gameStatusView)
        view.addSubview(wordLabelView)
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
