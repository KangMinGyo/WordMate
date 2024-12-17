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
        setupCards()
    }
    
    private func setupCards() {
        for (index, word) in viewModel.words.reversed().enumerated() {
            let cardView = FlashCardView(word: word)
            cardView.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.height * 0.6)
            cardView.layer.zPosition = CGFloat(-index)
            
            view.addSubview(cardView)
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
                }
            }
        default:
            break
        }
    }
}
