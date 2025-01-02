//
//  WordLabelView.swift
//  WordMate
//
//  Created by KangMingyo on 12/12/24.
//

import UIKit
import SnapKit
import Then

final class WordLabelView: UIView {
    
    // MARK: - Properties
    let feedbackLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
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
    }
    
    lazy var speakerButton = UIButton().then {
        $0.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .systemGray3
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        
        addSubview(feedbackLabel)
        addSubview(wordLabel)
        addSubview(meaningLabel)
        addSubview(speakerButton)
    }
    
    private func setupConstraints() {
        feedbackLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
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
        
        speakerButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(20)
        }
    }
}
