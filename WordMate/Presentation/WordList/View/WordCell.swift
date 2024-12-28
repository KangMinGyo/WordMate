//
//  WordCell.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import Then
import SnapKit

final class WordCell: UICollectionViewCell {
    
    // MARK: - Properties
    let speechService = SpeechService()
    
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
    
    let wordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
    }
    
    let pronunciationLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    let meaningLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .primaryOrange
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .gray
    }
    
    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .systemGray3
        $0.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }
    
    private lazy var speakerButton = UIButton().then {
        $0.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .systemGray3
        $0.addTarget(self, action: #selector(speakerButtonTapped), for: .touchUpInside)
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        speechService.delegate = self
        setupCellStyle()
        setupSubviews()
        setupConstraints()
        updateUIForExpansion()
    }
    
    private func setupCellStyle() {
        backgroundColor = .systemBackground
        layer.shadowColor = UIColor.systemGray3.cgColor
        layer.shadowOpacity = 0.5
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
            $0.top.equalToSuperview().offset(40)
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
    
    func updateUIForExpansion() {
        meaningLabel.isHidden = !isExpanded
        descriptionLabel.isHidden = descriptionLabel.text?.isEmpty ?? true || !isExpanded
    }
    
    // MARK: - UI Update Methods
    func configureUI() {
        wordLabel.text = viewModel?.name
        pronunciationLabel.text = viewModel?.pronunciation
        meaningLabel.text = viewModel?.meaning
        descriptionLabel.text = viewModel?.descriptionText
    }
    
    private func updateBookmarkButtonAppearance(isLiked: Bool) {
        bookmarkButton.setImage(isLiked ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
        bookmarkButton.tintColor = isLiked ? .primaryOrange : .systemGray3
    }
    
    // MARK: - Actions
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
}

// MARK: - SpeechServiceDelegate
extension WordCell: SpeechServiceDelegate {
    func speechDidStart() {
        DispatchQueue.main.async {
            self.speakerButton.tintColor = .primaryOrange
        }
    }
    
    func speechDidFinish() {
        DispatchQueue.main.async {
            self.speakerButton.tintColor = .systemGray3
        }
    }
}
