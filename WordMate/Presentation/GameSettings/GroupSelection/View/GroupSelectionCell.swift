//
//  GroupSelectionCell.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit

class GroupSelectionCell: UITableViewCell {
    
    let groupTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(groupTitleLabel)
    }
    
    private func setupConstraints() {
        groupTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
