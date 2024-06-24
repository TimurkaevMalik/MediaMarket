//
//  Delegates.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 18.06.2024.
//

import UIKit


protocol ProfileFactoryDelegate: AnyObject {
    func didExecuteRequest(_ profile: Profile)
    func didFailToLoadProfile(with error: ProfileServiceError)
    func didFailToUpdateProfile(with error: ProfileServiceError)
}

protocol ProfileControllerDelegate: AnyObject {
    func didEndRedactingProfile(_ profile: Profile)
}

protocol TextFieldAlertDelegate: UIViewController {
    func alertSaveTextButtonTappep(text: String?)
}
