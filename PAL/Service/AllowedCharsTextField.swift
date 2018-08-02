//
//  AllowedCharsTextField.swift
//  PAL
//
//  Created by admin on 8/2/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

// 1
class AllowedCharsTextField: UITextField, UITextFieldDelegate {
    
    // 2
    @IBInspectable var allowedChars: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 3
        delegate = self
        // 4
        autocorrectionType = .no
    }
    
    // 5
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 6
        guard string.count > 0 else {
            return true
        }
        
        // 7
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return prospectiveText.containsOnlyCharactersIn(matchCharacters: allowedChars)
    }
    
}


// 8
extension String {
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
}
