//
//  GroupSelectionViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit

class GroupSelectionViewController: UIViewController {
    
    let viewModel: GroupSelectionViewModel

    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = "학습할 그룹을 선택해주세요"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .primaryOrange
    }
    
    private let tableView = UITableView()
    
    private let selectionButton = UIButton().then {
        $0.setTitle("선택 완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .primaryOrange
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(selectionButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Initializer
    init(viewModel: GroupSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.fetchGroups()
        
        setupTableView()
        setupSubviews()
        setupConstraints()
    }
    
    @objc func selectionButtonTapped() {
        viewModel.onGroupSelected?(viewModel.selectedGroup)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupSelectionCell.self, forCellReuseIdentifier: "GroupSelectionCell")
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
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}

extension GroupSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSelectionCell", for: indexPath) as! GroupSelectionCell
        let group = viewModel.groups?[indexPath.row]
        cell.group = group
        return cell
    }
 
}

extension GroupSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedGroup = viewModel.groups?[indexPath.row]
    }
}
