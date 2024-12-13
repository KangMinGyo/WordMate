//
//  WordLabelView.swift
//  WordMate
//
//  Created by KangMingyo on 12/12/24.
//

import UIKit
import SnapKit
import Then

class WordLabelView: UIView {
    
    let feedbackLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    let wordLabel = UILabel().then {
        $0.text = "Word"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
    }
    
    lazy var speakerButton = UIButton().then {
        $0.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray  // 아이콘 색상 변경
    }
    
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
    
    private func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        
        addSubview(feedbackLabel)
        addSubview(wordLabel)
        addSubview(speakerButton)
    }
    
    private func setupConstraints() {
        feedbackLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        wordLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        speakerButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(20)
        }
    }
}
