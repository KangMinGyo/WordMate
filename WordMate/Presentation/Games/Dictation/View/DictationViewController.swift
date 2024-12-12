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

        setupSubviews()
        setupConstraints()
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
