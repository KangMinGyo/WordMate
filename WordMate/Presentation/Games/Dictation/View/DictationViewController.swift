//
//  DictationViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/12/24.
//

import UIKit

class DictationViewController: UIViewController {
    
    let viewModel: DictationViewModel
    let speechService = SpeechService()
    private var options: [MultipleChoiceOption] = []
    
    private let gameStatusView = GameStatusView()
    
    private let wordLabelView = WordLabelView()
    
    private lazy var dictationTextField = UITextField().then {
        $0.placeholder = "단어의 철자를 입력하세요."
        $0.borderStyle = .none
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addPadding()

    }
    
    // MARK: - Initializers
    init(viewModel: DictationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        dictationTextField.delegate = self
        setupGame()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupGame() {
        setupIndicator()
        setupWord()
        setupButtonActions()
    }
    
    private func setupIndicator() {
        gameStatusView.indicatorLabel.text = "\(viewModel.currentIndex + 1) / \(viewModel.totalWords)"
        gameStatusView.progressBar.progress = Float(viewModel.currentIndex + 1) / Float(viewModel.totalWords)
    }
    
    private func setupWord() {
        wordLabelView.wordLabel.text = viewModel.currentWord.meaning
    }
    
    private func setupButtonActions() {
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        wordLabelView.speakerButton.addTarget(self, action: #selector(speakerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func speakerButtonTapped() {
        let text = viewModel.currentWord.name
        speechService.speak(text)
    }
    
    private func goToNextWord(isCorrect: Bool, userAnswer: String) {
        let feedbackMessage = isCorrect ? "정답 🎉" : "오답 💪"
        let feedbackColor: UIColor = isCorrect ? .systemGreen : .systemRed
        wordLabelView.feedbackLabel.isHidden = false
        wordLabelView.feedbackLabel.text = feedbackMessage
        wordLabelView.feedbackLabel.textColor = feedbackColor
        
        dictationTextField.text = ""
        
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
        view.addSubview(dictationTextField)
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
        
        dictationTextField.snp.makeConstraints {
            $0.top.equalTo(wordLabelView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
    }
}

extension DictationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let userAnswer = dictationTextField.text else { return false }
        let isCorrect = viewModel.currentWord.name == userAnswer
        goToNextWord(isCorrect: isCorrect, userAnswer: userAnswer)
        return true
    }
}
