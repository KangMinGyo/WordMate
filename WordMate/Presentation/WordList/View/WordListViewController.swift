//
//  WordListViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit

class WordListViewController: UIViewController {

    var collectionView: UICollectionView!
    
    //MARK: - ViewModel
    let viewModel: WordListViewModel
    
    
    // MARK: - Initializers
    init(viewModel: WordListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupNaviBar()
        setupCollectionView()
        setupConstraints()
        bindViewModel()
        
        // Long Press Gesture 추가
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchWords()
        collectionView.reloadData()
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
                    self.updateActionSheetTapped(at: indexPath)
                }))
                actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                    self.deleteActionSheetTapped(at: indexPath)
                }))
                actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func updateActionSheetTapped(at indexPath: IndexPath) {
        viewModel.handleNextVC(at: indexPath.item, fromCurrentVC: self, animated: true)
    }
    
    func deleteActionSheetTapped(at indexPath: IndexPath) {
        viewModel.deleteGroup(at: indexPath.item)
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onWordsUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Setup Methods
    func setupNaviBar() {
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func addButtonTapped() {
        viewModel.handleNextVC(fromCurrentVC: self, animated: true)
    }
    
    private func setupCollectionView() {
        let itemWidth = (view.frame.width - 40)
        
        // 1. UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: itemWidth, height: 100)
        layout.minimumLineSpacing = 20  // 줄 간 간격
        
        // 2. UICollectionView 초기화
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 3. 셀 등록
        collectionView.register(WordCell.self, forCellWithReuseIdentifier: "WordCell")
        
        // 4. UICollectionView를 뷰에 추가
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WordListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
        
        let wordVM = viewModel.memberViewModelAtIndex(indexPath.row)
        cell.viewModel = wordVM
        return cell
    }
}

extension WordListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? WordCell {
            cell.isExpanded.toggle()
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }
}

extension WordListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WordCell else {
            return CGSize(width: collectionView.frame.width - 40, height: 100)
        }
        
        var height = cell.isExpanded == true ? 120 : 100
        
        if !cell.descriptionLabel.isHidden {
            height += 30
        }
        
        return CGSize(width: Int(collectionView.frame.width) - 40, height: height)
    }
}
