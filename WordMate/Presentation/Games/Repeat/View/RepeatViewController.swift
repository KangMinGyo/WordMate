//
//  RepeatViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/16/24.
//

import UIKit
import Then
import SnapKit

class RepeatViewController: UIViewController {

    let viewModel: RepeatViewModel
    
    private let gameStatusView = GameStatusView()
    private let wordLabelView = WordLabelView()
    
    weak var timer: Timer?
    private var isShowingMeaning = false
    
    private func customButton(image: UIImage?, imageSize: CGFloat, color: UIColor) -> UIButton {
        let button = UIButton()
        let resizedImage = image?.withConfiguration(UIImage.SymbolConfiguration(pointSize: imageSize, weight: .regular))
        
        var config = UIButton.Configuration.filled()
        config.image = resizedImage
        config.imagePadding = 10
        config.baseForegroundColor = color
        config.baseBackgroundColor = .systemBackground
        
        button.configuration = config
        
        return button
    }

    private lazy var playAndPauseButton = customButton(
        image: UIImage(systemName: "play.fill"),
        imageSize: 30,
        color: .primaryOrange
    )

    private lazy var stackView = UIStackView(arrangedSubviews: [
        wordLabelView, playAndPauseButton]).then {
            $0.axis = .vertical
            $0.spacing = 40
            $0.distribution = .fill
        }
    
    // MARK: - Initializers
    init(viewModel: RepeatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        wordLabelView.speakerButton.isHidden = true
        setupGame()
        setupButtonActions()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupIndicator() {
        gameStatusView.indicatorLabel.text = "\(viewModel.currentIndex) / \(viewModel.totalWords)"
        gameStatusView.progressBar.progress = Float(viewModel.currentIndex) / Float(viewModel.totalWords)
    }
    
    private func setupWord() {
        wordLabelView.wordLabel.text = viewModel.currentWord.name
        wordLabelView.meaningLabel.text = isShowingMeaning ? viewModel.currentWord.meaning : ""
    }
    
    private func setupGame() {
        setupIndicator()
        setupWord()
    }
    
    private func setupButtonActions() {
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        playAndPauseButton.addTarget(self, action: #selector(toggleTimer), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func toggleTimer() {
        if timer == nil {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        let resizedImage = UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        playAndPauseButton.setImage(resizedImage, for: .normal)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            goToNextWord()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        let resizedImage = UIImage(systemName: "play.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        playAndPauseButton.setImage(resizedImage, for: .normal)
    }
    
    private func goToNextWord() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.isShowingMeaning {
                self.isShowingMeaning = false
                self.viewModel.wordIndex += 1
            } else {
                self.isShowingMeaning = true
            }
            self.setupGame()
        }
    }

    private func setupSubviews() {
        view.addSubview(gameStatusView)
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        gameStatusView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
        
        playAndPauseButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(gameStatusView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
