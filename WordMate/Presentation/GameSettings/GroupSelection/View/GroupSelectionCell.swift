//
//  GroupSelectionCell.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit
import Then
import SnapKit

final class GroupSelectionCell: UITableViewCell {
    
    // MARK: - Properties
    var group: VocabularyGroup? {
        didSet {
            updateGroupData()
        }
    }
    
    private var groupTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .black
    }

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupSubviews() {
        addSubview(groupTitleLabel)
    }
    
    private func setupConstraints() {
        groupTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Update Methods
    private func updateGroupData() {
        groupTitleLabel.text = group?.name
    }
}
