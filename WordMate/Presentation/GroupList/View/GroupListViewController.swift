//
//  ViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/12/24.
//

import UIKit
import RealmSwift

class GroupListViewController: UIViewController {

    // MARK: - Properties
    var collectionView: UICollectionView!
    let viewModel: GroupListViewModel
    
    
    // MARK: - Initializer
    init(viewModel: GroupListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "단어 그룹"
        view.backgroundColor = .systemBackground
        
        setupNaviBar()
        setupCollectionView()
        setupConstraints()
        bindViewModel()
        
        // Long Press Gesture 추가
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchGroups()
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        
        switch gesture.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: point) {
                print("Long pressed at item \(indexPath.item)")
                let actionSheet = UIAlertController(title: "작업 선택", message: "원하는 작업을 선택하세요.", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
                print("수정")
                }))
                actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                print("삭제")
                }))
                actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onGroupsUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Navigation Bar Setup
    func setupNaviBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func addButtonTapped() {
        viewModel.goToAddGroupVC(from: self, animated: true)
    }
    
    
    // MARK: - CollectionView Setup
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
    
    // MARK: - Constraints Setup
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension GroupListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
        let group = viewModel.groups?[indexPath.row]
        cell.group = group
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GroupListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedGroup = viewModel.groups?[indexPath.item] else { return }
        viewModel.goToWordListVC(from: self, group: selectedGroup, animated: true)
    }
}
