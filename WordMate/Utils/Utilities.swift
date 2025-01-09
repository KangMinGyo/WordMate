//
//  Utilities.swift
//  WordMate
//
//  Created by KangMingyo on 1/9/25.
//

import UIKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage?, textField: UITextField) -> UIView {
        let view = UIView().then {
            $0.snp.makeConstraints { $0.height.equalTo(50) }
        }
        
        let imageView = UIImageView().then {
            $0.image = image
            $0.tintColor = .white
            $0.contentMode = .scaleAspectFit
        }
        
        let dividerView = UIView().then {
            $0.backgroundColor = .white
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(24)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.bottom.equalToSuperview().inset(8)
        }
        
        view.addSubview(dividerView)
        view.bringSubviewToFront(dividerView)
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.75)
        }
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField().then {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
            )
        }
        return tf
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attriburedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attriburedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attriburedTitle, for: .normal)
        
        return button
    }
    
    func createStackView(with views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }
}
