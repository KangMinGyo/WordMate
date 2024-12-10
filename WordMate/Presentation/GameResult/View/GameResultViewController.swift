//
//  GameResultViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/9/24.
//

import UIKit

class GameResultViewController: UIViewController {
    
    let viewModel: GameResultViewModel
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.frame.size = CGSize(width: 50, height: 50)
        $0.tintColor = .gray  // 아이콘 색상 변경
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "결과"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    private let circularProgress = CircularProgress(frame: CGRect(x: 0, y: 0, width: 200.0, height: 200.0)).then {
        $0.progressColor = .primaryOrange
        $0.trackColor = .systemGray
        $0.tag = 101
    }
    
    private let centerLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private let correctLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .black
    }
    
    private let wrongLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .black
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        correctLabel, wrongLabel]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
    
    private let grayLineView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    var collectionView: UICollectionView!
    
    // MARK: - Initializers
    init(viewModel: GameResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        setupResult()
        setupcollectionView()
        setupSubviews()
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupResult() {
        let percent = Int(Float(viewModel.correctAnswers) / Float(viewModel.totalQuestions) * 100)
        centerLabel.text = "\(percent)%"
        
        circularProgress.progressLayer.strokeEnd = CGFloat(viewModel.correctAnswers) / CGFloat(viewModel.totalQuestions)
        
        correctLabel.text = "✅ 정답: \(viewModel.correctAnswers)"
        wrongLabel.text = "❌ 오답: \(viewModel.wrongAnswers)"
    }
    
    private func setupcollectionView() {
        let itemWidth = (view.frame.width - 40)
        
        // 1. UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: itemWidth, height: 120)
        layout.minimumLineSpacing = 10  // 줄 간 간격
        
        // 2. UICollectionView 초기화
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        
        // 3. 셀 등록
        collectionView.register(ResultCell.self, forCellWithReuseIdentifier: "ResultCell")
        
        // 4. UICollectionView를 뷰에 추가
        view.addSubview(collectionView)
    }
    
    private func setupSubviews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(circularProgress)
        circularProgress.addSubview(centerLabel)
        view.addSubview(stackView)
        view.addSubview(grayLineView)
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        circularProgress.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(circularProgress.frame.width)
            $0.height.equalTo(circularProgress.frame.height)
        }
        
        centerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(circularProgress.snp.bottom).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        grayLineView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(grayLineView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

extension GameResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as! ResultCell
        let resultVM = viewModel.memberViewModelAtIndex(indexPath.row)
        cell.viewModel = resultVM
        return cell
    }
}
