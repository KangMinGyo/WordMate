//
//  GroupCell.swift
//  WordMate
//
//  Created by KangMingyo on 11/13/24.
//

import UIKit
import Then
import SnapKit

final class GroupCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var group: VocabularyGroup? {
        didSet { updateUI() }
    }
    
    private let groupTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .black
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        setupCellStyle()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupCellStyle() {
        backgroundColor = .systemBackground
        layer.shadowColor = UIColor.systemGray3.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func setupSubviews() {
        addSubview(groupTitleLabel)
    }
    
    private func setupConstraints() {
        groupTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func updateUI() {
        guard let group = group else { return }
        groupTitleLabel.text = group.name
    }
}

