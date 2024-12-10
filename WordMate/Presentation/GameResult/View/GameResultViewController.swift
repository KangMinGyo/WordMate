//
//  GameResultViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/9/24.
//

import UIKit

class GameResultViewController: UIViewController {
    
    private let circularProgress = CircularProgress(frame: CGRect(x: 10.0, y: 30.0, width: 100.0, height: 100.0)).then {
        $0.progressColor = .systemGray
        $0.trackColor = .primaryOrange
        $0.tag = 101
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        circularProgress.center = self.view.center
        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSubviews() {
        view.addSubview(circularProgress)
    }

    private func setupConstraints() {}
}
