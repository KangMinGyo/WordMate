//
//  UITextField+Extension.swift
//  WordMate
//
//  Created by KangMingyo on 12/13/24.
//

import UIKit

extension UITextField {
    func addPadding() {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        self.leftViewMode = .always
    }
}
