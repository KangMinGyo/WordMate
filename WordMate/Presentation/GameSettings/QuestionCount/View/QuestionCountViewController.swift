//
//  QuestionCountViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/3/24.
//

import UIKit
import Then
import SnapKit

class QuestionCountViewController: UIViewController {
    
    let viewModel: QuestionCountViewModel
    
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = "학습할 문제수를 선택해주세요"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let plusButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .primaryOrange
    }
    
    private let countLabel = UILabel().then {
        $0.text = "20"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        $0.textColor = .black
    }
    
    private let minusButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "minus.circle.fill", withConfiguration: imageConfig)
        $0.setImage(image, for: .normal)
        $0.tintColor = .primaryOrange
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        minusButton, countLabel, plusButton]).then {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.distribution = .fillEqually
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupBinding()
        setupButtonActions()
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Initializer
    init(viewModel: QuestionCountViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        viewModel.onCountChanged = { [weak self] newCount in
            self?.countLabel.text = "\(newCount)"
        }
    }
    
    private func setupButtonActions() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func plusButtonTapped() {
        viewModel.incrementCount(by: 5)
    }
    
    @objc func minusButtonTapped() {
        viewModel.decrementCount(by: 5)
    }
    
    @objc private func confirmButtonTapped() {
        viewModel.confirmCount()
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }
    }
}
