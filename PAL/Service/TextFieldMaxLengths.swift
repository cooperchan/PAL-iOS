//
//  TextFieldMaxLengths.swift
//  PAL
//
//  Created by admin on 8/2/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

// 1
private var maxLengths = [UITextField: Int]()

// 2
extension UITextField {
    
    // 3
    @IBInspectable var maxLength: Int {
        get {
            // 4
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            // 5
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControlEvents.editingChanged
            )
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        // 6
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
                return
        }
        
        let selection = selectedTextRange
        // 7
        text = prospectiveText.substring(with: prospectiveText.startIndex ..< prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength))
        
//        text = prospectiveText.substringWithRange(
//            Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advancedBy(maxLength))
//        )
        selectedTextRange = selection
    }
}
