//
//  ProfileProtocols.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 18.06.2024.
//

import UIKit

//enum AlertType {
//    case textFieldAlert(value: TextFieldAlert)
//    case defaultAlert(viewController: DefaultAlertDelegate)
//}
//
//struct TextFieldAlert {
//    let viewController: UIViewController
//    let delegate: AlertDelegateProtocol
//}

struct AlertModel {
    let title: String
    let message: String?
    let closeAlertTitle: String
    let completionTitle: String
    
    let completion: () -> Void
}
