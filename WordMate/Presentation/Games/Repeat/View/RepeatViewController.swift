//
//  RepeatViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/16/24.
//

import UIKit
import Then
import SnapKit

final class RepeatViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: RepeatViewModel
    private let gameStatusView = GameStatusView()
    private let wordLabelView = WordLabelView()
    
    weak var timer: Timer?
    private var isShowingMeaning = false
    
    private lazy var playAndPauseButton = createButton (
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGame()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        wordLabelView.speakerButton.isHidden = true
        setupButtonActions()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupButtonActions() {
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        playAndPauseButton.addTarget(self, action: #selector(toggleTimer), for: .touchUpInside)
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
    
    private func setupGame() {
        updateGameStatusIndicator()
        updateWordLabel()
    }
    
    private func updateGameStatusIndicator() {
        gameStatusView.indicatorLabel.text = viewModel.progressText
        gameStatusView.progressBar.progress = viewModel.progressValue
    }
    
    private func updateWordLabel() {
        wordLabelView.wordLabel.text = viewModel.currentWord.name
        wordLabelView.meaningLabel.text = isShowingMeaning ? viewModel.currentWord.meaning : ""
    }
    
    // MARK: - Helpers
    private func createButton(image: UIImage?, imageSize: CGFloat, color: UIColor) -> UIButton {
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
    
    private func toggleMeaning() {
        isShowingMeaning.toggle()
    }
    
    private func updatePlayAndPauseButton(isPlaying: Bool) {
        let icon = isPlaying ? RepeatConstants.Icon.pauseIcon : RepeatConstants.Icon.playIcon
        let resizedImage = icon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: RepeatConstants.Icon.buttonImageSize, weight: .regular))
        playAndPauseButton.setImage(resizedImage, for: .normal)
    }
    
    // MARK: - Actions
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
        updatePlayAndPauseButton(isPlaying: true)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            handleNextWord()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        updatePlayAndPauseButton(isPlaying: false)
    }
    
    private func handleNextWord() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.isShowingMeaning {
                self.viewModel.incrementCurrentIndex()
            }
            self.toggleMeaning()
            self.setupGame()
        }
    }
}
