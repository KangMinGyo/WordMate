//
//  GroupCell.swift
//  WordMate
//
//  Created by KangMingyo on 11/13/24.
//

import UIKit
import Then
import SnapKit

class GroupCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "GroupCell"
    
    var group: VocabularyGroup? {
        didSet {
            guard let group = group else { return }
            groupTitleLabel.text = group.name
        }
    }
    
    let groupTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .gray
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
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
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

