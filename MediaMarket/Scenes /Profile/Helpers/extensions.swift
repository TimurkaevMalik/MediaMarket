//
//  extensions.swift
//  MediaMarket
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

extension String {

    func cutString(at character: Character) -> String {

        var newString = ""

        for char in self {
            if char != character {
                newString.append(char)
            } else {
                break
            }
        }

        return newString
    }
}
