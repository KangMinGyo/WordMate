//
//  GameStatusView.swift
//  WordMate
//
//  Created by KangMingyo on 11/30/24.
//

import UIKit
import SnapKit
import Then

final class GameStatusView: UIView {
    
    // MARK: - Properties
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray
    }
    
    lazy var indicatorLabel = UILabel().then {
        $0.text = "0/20"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    lazy var progressBar = UIProgressView().then {
        $0.trackTintColor = .lightGray
        $0.progressTintColor = .primaryOrange
        $0.progress = 0.1
    }
    
    // MARK: - Initializer
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
    
    // MARK: - Setup Methods
    private func setupSubviews() {
        addSubview(backButton)
        addSubview(indicatorLabel)
        addSubview(progressBar)
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide)
        }
        
        indicatorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(indicatorLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
}
