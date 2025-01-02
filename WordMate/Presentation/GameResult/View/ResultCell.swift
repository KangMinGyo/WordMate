//
//  GameResultCell.swift
//  WordMate
//
//  Created by KangMingyo on 12/10/24.
//

import UIKit

final class ResultCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: ResultViewModel? {
        didSet {
            configureUI()
            updateBookmarkButtonAppearance()
        }
    }
    
    private let feedbackLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .systemGray
    }
    
    private let wordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }
    
    private let meaningLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .black
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        wordLabel, meaningLabel]).then {
            $0.axis = .vertical
            $0.spacing = 5
            $0.distribution = .fillEqually
        }
    
    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray
        $0.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellStyle()
        configureUI()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupCellStyle() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func setupSubviews() {
        addSubview(feedbackLabel)
        addSubview(stackView)
        addSubview(bookmarkButton)
    }
    
    private func setupConstraints() {
        feedbackLabel.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(feedbackLabel.snp.bottom).offset(10)
            $0.leading.bottom.equalToSuperview().inset(20)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func updateBookmarkButtonAppearance() {
        guard let isLiked = viewModel?.isLiked else { return }
        bookmarkButton.setImage(isLiked ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
        bookmarkButton.tintColor = isLiked ? .primaryOrange : .gray
    }

    // MARK: - UI Update Methods
    func configureUI() {
        feedbackLabel.text = viewModel?.feedback
        feedbackLabel.textColor = viewModel?.feedback == "정답" ? .systemGray : .primaryOrange
        
        wordLabel.text = viewModel?.name
        wordLabel.textColor = viewModel?.feedback == "정답" ? .systemGray : .black
        
        meaningLabel.text = viewModel?.meaning
        meaningLabel.textColor = viewModel?.feedback == "정답" ? .systemGray : .black
    }
    
    // MARK: - Actions
    @objc func bookmarkButtonTapped() {
        viewModel?.toggleIsLiked()
        updateBookmarkButtonAppearance()
    }
}
