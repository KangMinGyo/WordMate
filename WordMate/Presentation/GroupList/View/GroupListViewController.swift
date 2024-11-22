//
//  ViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/12/24.
//

import UIKit
import RealmSwift

class GroupListViewController: UIViewController {

    var collectionView: UICollectionView!
    
    let viewModel: GroupListViewModel
    
    init(viewModel: GroupListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "단어 그룹"
        view.backgroundColor = .systemBackground
        
        setupNaviBar()
        setupCollectionView()
        setupConstraints()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchGroups()
    }
    
    private func bindViewModel() {
        viewModel.onGroupsUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setupNaviBar() {
//        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        viewModel.goToAddGroupVC(from: self, animated: true)
    }
    
    private func setupCollectionView() {
        let itemWidth = (view.frame.width - 60) / 2
        
        // 1. UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 10  // 아이템 간 간격
        layout.minimumLineSpacing = 20  // 줄 간 간격
        
        // 2. UICollectionView 초기화
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 3. 셀 등록
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: GroupCell.identifier)
        
        // 4. UICollectionView를 뷰에 추가
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension GroupListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
//        let groupVM = ViewModel.
        cell.groupTitleLabel.text = viewModel.groups?[indexPath.row].name
        return cell
    }
}

extension GroupListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedGroup = viewModel.groups?[indexPath.item] else { return }
        viewModel.goToWordListVC(from: self, group: selectedGroup, animated: true)
    }
}
