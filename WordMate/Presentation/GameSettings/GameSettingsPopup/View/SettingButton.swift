//
//  SettingButton.swift
//  WordMate
//
//  Created by KangMingyo on 12/24/24.
//

import UIKit
import Then
import SnapKit

class SettingButton: UIButton {
    
    private let staticLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }
    
    private let dynamicLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .gray
        $0.textAlignment = .right
    }
    
//    private let iconImageView = UIImageView().then {
//        $0.image = UIImage(systemName: "greaterthan")
//        $0.tintColor = .systemGray
//        $0.contentMode = .scaleAspectFit
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(staticLabel)
        addSubview(dynamicLabel)
//        addSubview(iconImageView)
    }

    private func setupConstraints() {
        staticLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        dynamicLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
//        
//        iconImageView.snp.makeConstraints {
//            $0.edges.equalTo(popupView).inset(20)
//        }
    }
    
    func setStaticLabelText(_ text: String) {
        staticLabel.text = text
    }
    
    func setDynamicLabelText(_ text: String) {
        dynamicLabel.text = text
    }
}
