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
    
    let meaningLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .primaryOrange
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.isHidden = true
    }

    let leftLabel = UILabel().then {
        $0.text = "외웠어요😁"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .systemGreen
        $0.isHidden = true
    }
    
    let rightLabel = UILabel().then {
        $0.text = "모르겠어요😓"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .systemRed
        $0.isHidden = true
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
        addSubview(meaningLabel)
        addSubview(leftLabel)
        addSubview(rightLabel)
    }
    
    private func setupConstraints() {
        leftLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        rightLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        wordLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        meaningLabel.snp.makeConstraints {
            $0.top.equalTo(wordLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(with word: VocabularyWord) {
        wordLabel.text = word.name
        meaningLabel.text = word.meaning
    }
    
    func toggleMeaningVisibility() {
        meaningLabel.isHidden.toggle()
    }
}
