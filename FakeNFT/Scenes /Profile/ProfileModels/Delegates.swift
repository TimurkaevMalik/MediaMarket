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

protocol DefaultAlertDelegate: UIViewController {
    func callMethodActionTapped()
}

protocol AlertDelegateProtocol: AnyObject {
    func alertSaveButtonTappep(text: String?)
}
