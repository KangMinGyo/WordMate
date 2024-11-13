//
//  GroupCell.swift
//  WordMate
//
//  Created by KangMingyo on 11/13/24.
//

import UIKit

class GroupCell: UICollectionViewCell {
    static let identifier = "GroupCell"
    
    let groupTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .gray
        addSubview(groupTitleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            groupTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            groupTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
