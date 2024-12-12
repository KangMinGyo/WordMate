//
//  GameResultCell.swift
//  WordMate
//
//  Created by KangMingyo on 12/10/24.
//

import UIKit

class ResultCell: UICollectionViewCell {
    
    var viewModel: ResultViewModel? {
        didSet {
            configureUI()
            if let isLiked = viewModel?.isLiked {
                updateBookmarkButtonAppearance(isLiked: isLiked)
            }
        }
    }
    
    var feedbackLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .systemGray
    }
    
    var wordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }
    
    var meaningLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
        $0.tintColor = .gray  // 아이콘 색상 변경
        $0.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }
    
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
    
    private func setupCellStyle() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    @objc func bookmarkButtonTapped() {
        viewModel?.updateIsLiked()
        if let isLiked = viewModel?.isLiked {
            updateBookmarkButtonAppearance(isLiked: isLiked)
        }
    }
    
    private func updateBookmarkButtonAppearance(isLiked: Bool) {
        bookmarkButton.setImage(isLiked ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
        bookmarkButton.tintColor = isLiked ? .primaryOrange : .gray
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
    
    func configureUI() {
        feedbackLabel.text = viewModel?.feedback
        feedbackLabel.textColor = viewModel?.feedback == "정답" ? .primaryOrange : .systemGray
        wordLabel.text = viewModel?.name
        meaningLabel.text = viewModel?.meaning
    }
}
