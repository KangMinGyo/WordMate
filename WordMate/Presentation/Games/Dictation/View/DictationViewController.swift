//
//  DictationViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/12/24.
//

import UIKit

class DictationViewController: UIViewController {
    
    let viewModel: DictationViewModel
    private var options: [MultipleChoiceOption] = []
    
    private let gameStatusView = GameStatusView()
    
    private let wordLabelView = WordLabelView()
    
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
        setupGame()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupGame() {
        setupIndicator()
        setupWord()
    }
    
    private func setupIndicator() {
        gameStatusView.indicatorLabel.text = "\(viewModel.currentIndex + 1) / \(viewModel.totalWords)"
        gameStatusView.progressBar.progress = Float(viewModel.currentIndex + 1) / Float(viewModel.totalWords)
    }
    
    private func setupWord() {
        wordLabelView.wordLabel.text = viewModel.currentWord.name
    }

    private func setupSubviews() {
        view.addSubview(gameStatusView)
        view.addSubview(wordLabelView)
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
    }
}
