//
//  FlashCardViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/17/24.
//

import UIKit

class FlashCardViewController: UIViewController {
    
    let viewModel: FlashCardViewModel
    private var cardViews: [FlashCardView] = []
    
    private let gameStatusView = GameStatusView()
    
    // MARK: - Initializers
    init(viewModel: FlashCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        setupIndicator()
        setupCards()
    }
    
    private func setupIndicator() {
        gameStatusView.indicatorLabel.text = "\(viewModel.currentIndex) / \(viewModel.totalWords)"
        gameStatusView.progressBar.progress = Float(viewModel.currentIndex) / Float(viewModel.totalWords)
    }
    
    private func setupCards() {
        for (index, word) in viewModel.words.enumerated() {
            let cardView = FlashCardView(word: word)
            let width = view.frame.width - 40
            let height = view.frame.height * 0.6
            cardView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            cardView.center = view.center
            cardView.layer.zPosition = CGFloat(-index)
            
            view.addSubview(cardView)
            view.sendSubviewToBack(cardView)
            cardViews.append(cardView)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            cardView.addGestureRecognizer(panGesture)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view as? FlashCardView else { return }
        
        let translation = gesture.translation(in: view) // 드래그된 위치
        let rotationAngle = translation.x / view.bounds.width * 0.4 // 회전 각도 조절
        
        switch gesture.state {
        case .changed:
            card.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            if translation.x > 50 {
                // 오른쪽으로 넘겼을 때
                showSwipeMessage(on: card, isMemorized: true)
            } else if translation.x < -50 {
                // 왼쪽으로 넘겼을 때
                showSwipeMessage(on: card, isMemorized: false)
            }
            
        case .ended:
            if abs(translation.x) > 100 { // 스와이프 거리 기준
                // 스와이프 완료 - 카드 제거
                let direction: CGFloat = translation.x > 0 ? 1 : -1
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center.x += direction * self.view.frame.width
                }) { _ in
                    card.removeFromSuperview()
                    self.cardViews.removeLast()
                }
            } else {
                // 원래 위치로 되돌리기
                UIView.animate(withDuration: 0.3) {
                    card.center = self.view.center
                    card.transform = .identity
                    self.hideSwipeLabels(on: card)
                }
            }
        default:
            break
        }
    }
    
    private func showSwipeMessage(on card: FlashCardView, isMemorized: Bool) {
        if isMemorized {
            card.rightLabel.isHidden = false
            card.leftLabel.isHidden = true
        } else {
            card.leftLabel.isHidden = false
            card.rightLabel.isHidden = true
        }
    }
    
    private func hideSwipeLabels(on card: FlashCardView) {
        card.leftLabel.isHidden = true
        card.rightLabel.isHidden = true
    }
    
    private func setupSubviews() {
        view.addSubview(gameStatusView)
    }

    private func setupConstraints() {
        gameStatusView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }
}
