//
//  QuestionSelectionCell.swift
//  WordMate
//
//  Created by KangMingyo on 12/4/24.
//

import UIKit
import Then
import SnapKit

final class QuestionSelectionCell: UITableViewCell {

    // MARK: - Properties
    var selectLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .black
    }
    
    lazy var selectButton = UIButton().then {
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray
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
        addSubview(selectLabel)
        addSubview(selectButton)
    }
    
    private func setupConstraints() {
        selectLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide)
            $0.centerY.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Update Methods
    func configure(with text: String, isSelected: Bool) {
        selectLabel.text = text
        updateSelectionState(isSelected: isSelected)
    }

    private func updateSelectionState(isSelected: Bool) {
        let imageName = isSelected ? "checkmark.circle.fill" : "circle"
        selectButton.setImage(UIImage(systemName: imageName), for: .normal)
        selectButton.tintColor = isSelected ? .primaryOrange : .gray
    }
}

