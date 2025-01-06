//
//  WordListViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit
import Then
import SnapKit

final class WordListViewController: UIViewController {

    // MARK: - Properties
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private let viewModel: WordListViewModel
    
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
        setupView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchWords()
        setupView()
        setupGestures()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        setupNaviBar()
        setupSearchBar()
        setupCollectionView()
        setupConstraints()
        bindViewModel()
    }
    
    func setupNaviBar() {
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "검색할 단어를 입력해 주세요."
        searchBar.backgroundImage = UIImage() // border line 제거
        view.addSubview(searchBar)
    }
    
    private func setupCollectionView() {
        let itemWidth = (view.frame.width - WordListConstants.horizontalPadding * 2)
        
        // 1. UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: WordListConstants.verticalPadding, left: WordListConstants.horizontalPadding, bottom: 0, right: WordListConstants.horizontalPadding)
        layout.itemSize = CGSize(width: itemWidth, height: WordListConstants.itemHeight)
        layout.minimumLineSpacing = WordListConstants.lineSpacing
        
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
        viewModel.onWordsUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    @objc func addButtonTapped() {
        viewModel.navigateToAddWordVC(from: self, animated: true)
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
            self.updateWord(at: indexPath)
        }))
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deleteWord(at: indexPath)
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func updateWord(at indexPath: IndexPath) {
        viewModel.navigateToAddWordVC(from: self, at: indexPath.item, animated: true)
    }
    
    func deleteWord(at indexPath: IndexPath) {
        viewModel.deleteWord(at: indexPath.item)
    }
}

// MARK: - UISearchBarDelegate
extension WordListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewModel.searchWords(text: text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.searchWords(text: text)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.fetchWords()
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
extension WordListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
        
        let wordVM = viewModel.memberViewModel(at: indexPath.row)
        cell.viewModel = wordVM
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WordListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? WordCell {
            cell.isExpanded.toggle()
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
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
