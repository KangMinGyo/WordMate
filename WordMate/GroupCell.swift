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
    static let identifier = "GroupCell"
    
    let groupTitleLabel = UILabel().then {
        $0.text = "Title"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .white
    }
    
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
        backgroundColor = .systemGray3
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

