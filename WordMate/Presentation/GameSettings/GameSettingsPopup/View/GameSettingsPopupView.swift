//
//  GameSettingsPopupView.swift
//  WordMate
//
//  Created by KangMingyo on 11/28/24.
//

import UIKit
import Then
import SnapKit

final class GameSettingsPopupView: UIView {

    // MARK: - Properties
    var backAction: (() -> Void)?
    var startAction: (() -> Void)?
    
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    lazy var groupSelectionButton = createSettingButton(title: "그룹 선택", dynamicText: "그룹을 선택해주세요")
    lazy var wordSelectionTypeButton = createSettingButton(title: "문제 선택", dynamicText: "모든 단어")
    lazy var wordOrderButton = createSettingButton(title: "문제 순서", dynamicText: "순서대로")
    lazy var wordCountButton = createSettingButton(title: "문제 개수", dynamicText: "20개")
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        groupSelectionButton, wordSelectionTypeButton, wordOrderButton, wordCountButton]).then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    
    private lazy var startButton = UIButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.backgroundColor = .systemGray3
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        $0.isEnabled = false
    }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        self.backgroundColor = .black.withAlphaComponent(0.3)
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(popupView)
        popupView.addSubview(backButton)
        popupView.addSubview(titleLabel)
        popupView.addSubview(stackView)
        popupView.addSubview(startButton)
    }

    private func setupConstraints() {
        popupView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
            $0.height.greaterThanOrEqualTo(350) // 최소 높이 설정
        }
        
        backButton.snp.makeConstraints {
            $0.top.leading.equalTo(popupView).inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(popupView).inset(20)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        backAction?()
    }
    
    @objc private func startButtonTapped() {
        startAction?()
    }
    
    private func createSettingButton(title: String, dynamicText: String) -> SettingButton {
        let button = SettingButton(frame: .zero)
        button.setStaticLabelText(title)
        button.setDynamicLabelText(dynamicText)
        return button
    }
    
    func updateStartButtonState(isEnabled: Bool) {
        startButton.isEnabled = isEnabled
        startButton.backgroundColor = isEnabled ? .primaryOrange : .systemGray3
    }
    
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
}
