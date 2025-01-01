//
//  FlashCardViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/17/24.
//

import UIKit

final class FlashCardViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: FlashCardViewModel
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

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupGameStatusView()
        setupCards()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupGameStatusView() {
        gameStatusView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        updateGameStatusIndicator()
    }
    
    private func setupCards() {
        for (index, word) in viewModel.words.enumerated() {
            let cardView = createCardView(for: word, at: index)
            cardViews.append(cardView)
            view.addSubview(cardView)
            view.sendSubviewToBack(cardView)
        }
    }
    
    private func createCardView(for word: VocabularyWord, at index: Int) -> FlashCardView {
        let cardView = FlashCardView(word: word)
        let cardWidth = view.frame.width - FlashCardConstants.cardHorizontalMargin * 2
        let cardHeight = view.frame.height * FlashCardConstants.cardHeightRatio
        
        cardView.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        cardView.center = view.center
        cardView.layer.zPosition = CGFloat(-index)
        
        addGestureRecognizers(to: cardView)
        return cardView
    }
    
    private func addGestureRecognizers(to cardView: FlashCardView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        cardView.addGestureRecognizer(panGesture)
        cardView.addGestureRecognizer(tapGesture)
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
    
    // MARK: - Helper Methods
    private func updateGameStatusIndicator() {
        gameStatusView.indicatorLabel.text = viewModel.progressText
        gameStatusView.progressBar.progress = viewModel.progressValue
    }
    
    // 카드 넘기기(제거)
    private func handleCardSwipe(_ card: FlashCardView, translation: CGPoint) {
        let direction: CGFloat = translation.x > 0 ? 1 : -1
        saveUserResponse(isCorrect: !(direction > 0)) // 유저 응답 저장
        
        UIView.animate(withDuration: 0.3) {
            card.center.x += direction * self.view.frame.width
        } completion: { _ in
            self.removeSwipedCard(card)
        }
    }

    private func removeSwipedCard(_ card: FlashCardView) {
        viewModel.incrementCurrentIndex()
        cardViews.removeLast()
        card.removeFromSuperview()
        
        if viewModel.isGameComplete {
            viewModel.navigateToGameResultVC(from: self, animated: true)
        } else {
            updateGameStatusIndicator()
        }
    }
    
    // 카드 상태 초기화(되돌리기)
    private func resetCardPosition(_ card: FlashCardView) {
        UIView.animate(withDuration: 0.3) {
            card.center = self.view.center
            card.transform = .identity
            self.hideSwipeLabels(on: card)
        }
    }
    
    private func showSwipeMessage(on card: FlashCardView, isMemorized: Bool) {
        card.rightLabel.isHidden = !isMemorized
        card.leftLabel.isHidden = isMemorized
    }
    
    private func hideSwipeLabels(on card: FlashCardView) {
        card.leftLabel.isHidden = true
        card.rightLabel.isHidden = true
    }
    
    private func saveUserResponse(isCorrect: Bool) {
        viewModel.appendUserResponse(isCorrect: isCorrect)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view as? FlashCardView else { return }
        let translation = gesture.translation(in: view) // 드래그된 위치
        let rotationAngle = translation.x / view.bounds.width * FlashCardConstants.rotationFactor
        
        switch gesture.state {
        case .changed:
            card.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            showSwipeMessage(on: card, isMemorized: translation.x > 0)
            
        case .ended:
            if abs(translation.x) > FlashCardConstants.swipeThreshold { // 스와이프 거리 기준
                handleCardSwipe(card, translation: translation)
            } else {
                resetCardPosition(card)
            }
        default:
            break
        }
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let card = gesture.view as? FlashCardView else { return }
        card.toggleMeaningVisibility()
    }
}
