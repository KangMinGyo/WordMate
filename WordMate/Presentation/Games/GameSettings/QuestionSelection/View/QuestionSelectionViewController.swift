//
//  QuestionSelectionViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/3/24.
//

import UIKit
import Then
import SnapKit

final class QuestionSelectionViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: QuestionSelectionViewModel

    private let titleLabel = UILabel().then {
        $0.text = "학습할 단어를 선택해주세요"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let tableView = UITableView()
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    // MARK: - Initializer
    init(viewModel: QuestionSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupTableView()
        setupButtonActions()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.register(QuestionSelectionCell.self, forCellReuseIdentifier: "QuestionSelectionCell")
    }
    
    private func setupButtonActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - Actions
    @objc private func confirmButtonTapped() {
        let currentSelection = viewModel.currentSelection()
        viewModel.onQuestionSelected?(currentSelection)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension QuestionSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionSelectionCell", for: indexPath) as! QuestionSelectionCell
        let text = viewModel.option(at: indexPath)
        let isSelected = viewModel.isSelected(at: indexPath)
        cell.configure(with: text, isSelected: isSelected)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension QuestionSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectOption(at: indexPath)
        tableView.reloadData()
    }
}
