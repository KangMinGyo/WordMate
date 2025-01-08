//
//  GroupSelectionViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit
import Then
import SnapKit

final class GroupSelectionViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: GroupSelectionViewModel

    private let titleLabel = UILabel().then {
        $0.text = "학습할 그룹을 선택해주세요"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let tableView = UITableView()
    
    private let selectionButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
    }
    
    // MARK: - Initializer
    init(viewModel: GroupSelectionViewModel) {
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
        viewModel.fetchGroups()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupSelectionCell.self, forCellReuseIdentifier: "GroupSelectionCell")
    }
    
    private func setupButtonActions() {
        selectionButton.addTarget(self, action: #selector(selectionButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(selectionButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        selectionButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - Actions
    @objc private func selectionButtonTapped() {
        viewModel.onGroupSelected?(viewModel.selectedGroup)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension GroupSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSelectionCell", for: indexPath) as! GroupSelectionCell
        let group = viewModel.group(at: indexPath.row)
        cell.group = group
        return cell
    }
 
}

// MARK: - UITableViewDelegate
extension GroupSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedGroup = viewModel.group(at: indexPath.row)
    }
}
