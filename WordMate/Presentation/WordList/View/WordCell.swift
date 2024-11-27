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
    
    var viewModel: WordViewModel? {
        didSet {
            configureUI()
            if let isLiked = viewModel?.isLiked {
                updateBookmarkButtonAppearance(isLiked: isLiked)
            }
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            updateUIForExpansion()
        }
    }
    
    let speechService = SpeechService()
    
    let wordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = .black
    }
    
    let pronunciationLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    let meaningLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
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
        $0.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }
    
    private lazy var speakerButton = UIButton().then {
        $0.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray  // 아이콘 색상 변경
        $0.addTarget(self, action: #selector(speakerButtonTapped), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        speechService.delegate = self
        setupCellStyle()
        setupSubviews()
        setupConstraints()
        updateUIForExpansion()
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
            $0.top.equalToSuperview().offset(35)
            $0.centerX.equalToSuperview()
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
    
    func configureUI() {
        wordLabel.text = viewModel?.name
        pronunciationLabel.text = viewModel?.pronunciation
        meaningLabel.text = viewModel?.meaning
        descriptionLabel.text = viewModel?.descriptionText
    }
    
    func updateUIForExpansion() {
        meaningLabel.isHidden = !isExpanded
        if let descriptionText = descriptionLabel.text, descriptionText.isEmpty {
            descriptionLabel.isHidden = true
        } else {
            descriptionLabel.isHidden = !isExpanded
        }
    }
    
    @objc func speakerButtonTapped() {
        guard let text = viewModel?.name else { return }
        speechService.speak(text)
    }
    
    @objc func bookmarkButtonTapped() {
        viewModel?.updateIsLiked()
        if let isLiked = viewModel?.isLiked {
            updateBookmarkButtonAppearance(isLiked: isLiked)
        }
    }
    
    private func updateBookmarkButtonAppearance(isLiked: Bool) {
        bookmarkButton.setImage(isLiked ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
        bookmarkButton.tintColor = isLiked ? .yellow : .gray
    }
}

// MARK: - Delegate Methods
extension WordCell: SpeechServiceDelegate {
    func speechDidStart() {
        DispatchQueue.main.async {
            self.speakerButton.tintColor = .green2
        }
    }
    
    func speechDidFinish() {
        DispatchQueue.main.async {
            self.speakerButton.tintColor = .gray
        }
    }
}
