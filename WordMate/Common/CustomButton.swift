//
//  CustomButton.swift
//  WordMate
//
//  Created by KangMingyo on 12/30/24.
//

import UIKit

final class CustomButton: UIButton {
    
    init(title: String, subtitle: String, image: UIImage?) {
        super.init(frame: .zero)
        configureButton(title: title, subtitle: subtitle, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(title: String, subtitle: String, image: UIImage?) {
        var config = UIButton.Configuration.filled()
        
        // 기본 설정
        config.image = image
        config.imagePadding = 10
        config.baseBackgroundColor = .white
        
        // 이미지 색상 설정
        config.imageColorTransformer = UIConfigurationColorTransformer { _ in
            return .primaryOrange
        }
        
        // 타이틀 & 서브타이틀 색상 설정
        let titleAttributes = AttributedString(title, attributes: .init([
            .foregroundColor: UIColor.black
        ]))
        config.attributedTitle = titleAttributes

        let subtitleAttributes = AttributedString(subtitle, attributes: .init([
            .foregroundColor: UIColor.gray
        ]))
        config.attributedSubtitle = subtitleAttributes

        // 테두리 설정
        config.background.strokeWidth = 1.0
        config.background.strokeColor = .systemGray5
        config.cornerStyle = .medium
        
        self.configuration = config
    }
}
