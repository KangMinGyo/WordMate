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
    
    private func customButton(title: String) -> UIButton {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(systemName: "arrowtriangle.forward.fill")
        config.imagePadding = 10
        config.baseForegroundColor = .black
        config.cornerStyle = .medium
        
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        return button
    }

    private lazy var groupSelectionButton = customButton(title: "그룹선택")
    private lazy var wordSelectionTypeButton = customButton(title: "문제 선택")
    private lazy var wordOrderButton = customButton(title: "문제 순서")
    private lazy var wordCountButton = customButton(title: "문제 개수")
    
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
