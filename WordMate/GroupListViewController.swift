//
//  ViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/12/24.
//

import UIKit

class GroupListViewController: UIViewController {

    var collectionView: UICollectionView!
    
    // 데이터 배열
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let itemWidth = (view.frame.width - 30) / 2
        
        // 1. UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 10  // 아이템 간 간격
        layout.minimumLineSpacing = 10  // 줄 간 간격
        
        // 2. UICollectionView 초기화
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white  // 배경색 설정
        collectionView.dataSource = self  // 데이터 소스 설정
        collectionView.delegate = self  // delegate 설정
        
        // 3. 셀 등록
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: GroupCell.identifier)
        
        // 4. UICollectionView를 뷰에 추가
        view.addSubview(collectionView)
    }


}

extension GroupListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
        cell.groupTitleLabel.text = "Title"
        return cell
    }
    
}
