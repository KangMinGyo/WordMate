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
    
    private let wordLabelView = WordLabelView()
    
    private let backwardButton = UIButton().then {
        $0.setImage(UIImage(systemName: "backward.fill"), for: .normal)
    }
    
    private let pauseButton = UIButton().then {
        $0.setImage(UIImage(systemName: "play.fill"), for: .normal) // pause.fill
        $0.tintColor = .primaryOrange
    }
    
    private let forwardButton = UIButton().then {
        $0.setImage(UIImage(systemName: "forward.fill"), for: .normal)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        backwardButton, pauseButton, forwardButton]).then {
            $0.axis = .horizontal
            $0.spacing = 40
            $0.distribution = .fillEqually
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
        
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        view.addSubview(wordLabelView)
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        wordLabelView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(300)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(wordLabelView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
    }
}
