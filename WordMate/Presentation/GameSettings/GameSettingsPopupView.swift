//
//  GameSettingsPopupView.swift
//  WordMate
//
//  Created by KangMingyo on 11/28/24.
//

import UIKit
import Then
import SnapKit

class GameSettingsPopupView: UIView {

    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
    }

    private lazy var groupSelectionButton = UIButton().then {
        $0.setTitle("학습할 그룹 선택", for: .normal)
        $0.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        $0.tintColor = .gray  // 아이콘 색상 변경
//        $0.addTarget(self, action: #selector(), for: .touchUpInside)
    }

    private lazy var wordSelectionTypeButton = UIButton().then {
        $0.setTitle("출제할 문제 선택", for: .normal)
        $0.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        $0.tintColor = .gray  // 아이콘 색상 변경
//        $0.addTarget(self, action: #selector(), for: .touchUpInside)
    }

    private lazy var wordOrderButton = UIButton().then {
        $0.setTitle("문제 순서", for: .normal)
        $0.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        $0.tintColor = .gray  // 아이콘 색상 변경
//        $0.addTarget(self, action: #selector(), for: .touchUpInside)
    }
    
    private lazy var wordCountButton = UIButton().then {
        $0.setTitle("문제 개수", for: .normal)
        $0.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        $0.tintColor = .gray  // 아이콘 색상 변경
//        $0.addTarget(self, action: #selector(), for: .touchUpInside)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        groupSelectionButton, wordSelectionTypeButton, wordOrderButton, wordCountButton]).then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    
    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        
        self.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(popupView)
        popupView.addSubview(titleLabel)
        popupView.addSubview(stackView)
    }

    private func setupConstraints() {
        popupView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(popupView).offset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(popupView).inset(20)
            $0.bottom.equalTo(popupView).offset(-20)
        }
    }
}
