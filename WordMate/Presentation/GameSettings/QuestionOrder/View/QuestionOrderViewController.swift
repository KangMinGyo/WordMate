//
//  QuestionOrderViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/4/24.
//

import UIKit

class QuestionOrderViewController: UIViewController {

    let viewModel: QuestionOrderViewModel

    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = "학습할 순서를 선택해주세요"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .primaryOrange
    }
    
    private let tableView = UITableView()
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    // MARK: - Initializer
    init(viewModel: QuestionOrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @objc private func confirmButtonTapped() {
        let currentSelection = viewModel.currentSelection()
        viewModel.onQuestionOrderSelected?(currentSelection)
        dismiss(animated: true, completion: nil)
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
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
}

extension QuestionOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionSelectionCell", for: indexPath) as! QuestionSelectionCell
        cell.selectionStyle = .none
        cell.selectLabel.text = viewModel.options(indexPath)
        let isSelected = viewModel.isSelected(indexPath)
        cell.updateSelectionState(isSelected: isSelected)
        return cell
    }
}

extension QuestionOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectOption(indexPath)
        tableView.reloadData()
    }
}
