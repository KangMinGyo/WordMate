//
//  FlashCardView.swift
//  WordMate
//
//  Created by KangMingyo on 12/17/24.
//

import UIKit

class FlashCardView: UIView {

    let wordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    init(word: VocabularyWord) {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        configure(with: word)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20

        addSubview(wordLabel)
    }
    
    private func setupConstraints() {
        wordLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with word: VocabularyWord) {
        wordLabel.text = word.name
    }
}
