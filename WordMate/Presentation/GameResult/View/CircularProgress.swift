//
//  CircularProgress.swift
//  WordMate
//
//  Created by KangMingyo on 12/9/24.
//

import UIKit

final class CircularProgress: UIView {
    
    // MARK: - Properties
    let progressLayer = CAShapeLayer()
    let tracklayer = CAShapeLayer()
    
    var progressColor:UIColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor:UIColor = UIColor.white {
        didSet {
            tracklayer.strokeColor = trackColor.cgColor
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = frame.size.width / 2.0
        createCircularPath()
    }
    
    private func createCircularPath() {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
            radius: (frame.size.width - 1.5)/2, 
            startAngle: CGFloat(-0.5 * Double.pi),
            endAngle: CGFloat(1.5 * Double.pi),
            clockwise: true
        )
        
        configureLayer(tracklayer, path: circlePath, strokeColor: trackColor, strokeEnd: 1.0)
        configureLayer(progressLayer, path: circlePath, strokeColor: progressColor, strokeEnd: 0.0)
    }
    
    private func configureLayer(_ layer: CAShapeLayer, path: UIBezierPath, strokeColor: UIColor, strokeEnd: CGFloat) {
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10.0
        layer.strokeEnd = strokeEnd
        self.layer.addSublayer(layer)
    }
}
