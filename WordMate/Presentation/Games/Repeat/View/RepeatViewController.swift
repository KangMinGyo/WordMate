//
//  RepeatViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/16/24.
//

import UIKit

class RepeatViewController: UIViewController {

    private let wordLabelView = WordLabelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        view.addSubview(wordLabelView)
    }

    private func setupConstraints() {
        wordLabelView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(300)
        }
    }
}
