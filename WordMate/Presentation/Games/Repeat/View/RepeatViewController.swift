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
    
    private lazy var backwardButton = customButton(
        image: UIImage(systemName: "backward.fill"), 
        imageSize: 20,
        color: .systemGray
    )
    
    private lazy var pauseButton = customButton(
        image: UIImage(systemName: "play.fill"),
        imageSize: 30,
        color: .primaryOrange
    )
    
    private lazy var forwardButton = customButton(
        image: UIImage(systemName: "forward.fill"),
        imageSize: 20,
        color: .systemGray
    )
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        backwardButton, pauseButton, forwardButton]).then {
            $0.axis = .horizontal
            $0.spacing = 40
            $0.distribution = .fillEqually
        }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        wordLabelView, buttonStackView]).then {
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
        setupIndicator()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupIndicator() {
        gameStatusView.indicatorLabel.text = "\(viewModel.currentIndex + 1) / \(viewModel.totalWords)"
        gameStatusView.progressBar.progress = Float(viewModel.currentIndex + 1) / Float(viewModel.totalWords)
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
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(gameStatusView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
