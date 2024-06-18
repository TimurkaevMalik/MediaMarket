//
//  Delegates.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 18.06.2024.
//

import UIKit

protocol ProfileControllerDelegate: AnyObject {
    func didEndRedactingProfile(_ profile: ProfileResult)
}

protocol TextFieldAlertDelegate: UIViewController {
    func alertSaveTextButtonTappep(text: String?)
}
