//
//  WordCell.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import Then
import SnapKit

class WordCell: UICollectionViewCell {
    
    let wordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = .black
    }
    
    let pronunciationLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    let meaningLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .black
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .gray
    }
    
    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray  // 아이콘 색상 변경
    }
    
    private lazy var speakerButton = UIButton().then {
        $0.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray  // 아이콘 색상 변경
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupCellStyle()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupCellStyle() {
        backgroundColor = .systemGray6
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func setupSubviews() {
        addSubview(wordLabel)
        addSubview(pronunciationLabel)
        addSubview(meaningLabel)
        addSubview(descriptionLabel)
        addSubview(bookmarkButton)
        addSubview(speakerButton)
    }
    
    private func setupConstraints() {
        wordLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        pronunciationLabel.snp.makeConstraints {
            $0.top.equalTo(wordLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        meaningLabel.snp.makeConstraints {
            $0.top.equalTo(pronunciationLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(meaningLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        speakerButton.snp.makeConstraints {
            $0.bottom.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configure() {
        wordLabel.text = "Apple"
        pronunciationLabel.text = "[애펄]"
        meaningLabel.text = "사과"
        descriptionLabel.text = "맛있는 사과"
    }
}
