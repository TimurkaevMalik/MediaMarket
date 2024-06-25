//
//  extensions.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 25.06.2024.
//

import UIKit


extension NSMutableAttributedString {
    
    func setFont(_ font: UIFont, forText text: String) {
        
        let range = self.mutableString.range(of: text, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}
