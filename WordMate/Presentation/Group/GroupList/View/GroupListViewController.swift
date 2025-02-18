//
//  ViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/12/24.
//

import UIKit
import Then
import SnapKit

final class GroupListViewController: UIViewController {

    // MARK: - Properties
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private let viewModel: GroupListViewModel
    
    
    // MARK: - Initializer
    
    init(viewModel: GroupListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchGroups()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        navigationItem.title = "단어 그룹"
        view.backgroundColor = .systemBackground
        
        setupNaviBar()
        setupSearchBar()
        setupCollectionView()
        setupConstraints()
        bindViewModel()
    }
    
    private func setupNaviBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "검색할 그룹을 입력해 주세요."
        searchBar.backgroundImage = UIImage() // border line 제거
        view.addSubview(searchBar)
    }
    
    private func setupCollectionView() {
        let totalSpacing = (GroupListConstants.horizontalPadding * 2) + GroupListConstants.interItemSpacing
        let itemWidth = (view.frame.width - totalSpacing) / 2
        
        // 1. UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: GroupListConstants.horizontalPadding, bottom: 0, right: GroupListConstants.horizontalPadding)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = GroupListConstants.interItemSpacing
        layout.minimumLineSpacing = GroupListConstants.interItemSpacing
        
        // 2. UICollectionView 초기화
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 3. 셀 등록
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: Cell.groupCellIdentifier)
        
        // 4. UICollectionView를 뷰에 추가
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    private func bindViewModel() {
        viewModel.onGroupsUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        viewModel.navigateToAddGroupVC(from: self, animated: true)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        presentActionSheet(for: indexPath)
    }
    
    private func presentActionSheet(for indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: "작업 선택", message: "원하는 작업을 선택하세요.", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
        print("수정")
            self.updateGroup(at: indexPath)
        }))
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deleteGroup(at: indexPath)
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func updateGroup(at indexPath: IndexPath) {
        viewModel.navigateToAddGroupVC(from: self, at: indexPath.item, animated: true)
    }
    
    private func deleteGroup(at indexPath: IndexPath) {
        viewModel.deleteGroup(at: indexPath.item)
    }
}

// MARK: - UISearchBarDelegate

extension GroupListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewModel.searchGroups(text: text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.searchGroups(text: text)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.fetchGroups()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        customizeCancelButton(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    private func customizeCancelButton(_ searchBar: UISearchBar) {
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.setTitleColor(.gray, for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension GroupListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.groupCellIdentifier, for: indexPath) as! GroupCell
        let group = viewModel.groupList?[indexPath.row]
        cell.group = group
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension GroupListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedGroup = viewModel.groupList?[indexPath.item] else { return }
        viewModel.navigateToWordListVC(from: self, group: selectedGroup, animated: true)
    }
}

