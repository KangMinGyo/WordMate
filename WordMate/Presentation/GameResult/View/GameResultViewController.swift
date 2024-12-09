//
//  GameResultViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/9/24.
//

import UIKit

class GameResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let circularProgress = CircularProgress(frame: CGRect(x: 10.0, y: 30.0, width: 100.0, height: 100.0))
        circularProgress.progressColor = UIColor(red: 52.0/255.0, green: 141.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        circularProgress.trackColor = UIColor(red: 52.0/255.0, green: 141.0/255.0, blue: 252.0/255.0, alpha: 0.6)
        circularProgress.tag = 101
        circularProgress.center = self.view.center
        self.view.addSubview(circularProgress)
        
        //animate progress
//        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
    }
    
//    @objc func animateProgress() {
//        let cp = self.view.viewWithTag(101) as! CircularProgress
//        cp.setProgressWithAnimation(duration: 1.0, value: 0.8)
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
