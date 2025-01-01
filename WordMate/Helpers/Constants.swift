//
//  Constants.swift
//  WordMate
//
//  Created by KangMingyo on 1/1/25.
//

import UIKit

public enum FlashCardConstants {
    static let cardHorizontalMargin: CGFloat = 20
    static let cardHeightRatio: CGFloat = 0.6
    static let swipeThreshold: CGFloat = 100
    static let rotationFactor: CGFloat = 0.4
    
    enum Text {
        static let memorized = "외웠어요😁"
        static let notMemorized = "모르겠어요😓"
    }
}

public enum RepeatConstants {
    enum Icon {
        static let playIcon = UIImage(systemName: "play.fill")
        static let pauseIcon = UIImage(systemName: "pause.fill")
        static let buttonImageSize: CGFloat = 30
    }
}
