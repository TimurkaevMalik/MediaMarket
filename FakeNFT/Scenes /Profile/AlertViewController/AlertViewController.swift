//
//  AlertViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 16.06.2024.
//

import UIKit

protocol AlertDelegateProtocol: AnyObject {
    func alertSaveButtonTappep(text: String?)
}

enum AlertType {
    case textFieldAlert(value: TextFieldAlert)
    case defaultAlert(value: DefaultAlert)
}

struct TextFieldAlert {
    let viewController: UIViewController
    let delegate: AlertDelegateProtocol
}

struct DefaultAlert {
    let viewController: UIViewController
}

final class AlertPresenter {
    
    let alertType: AlertType
    
    init(type: AlertType) {
        alertType = type
    }
   
    func textFieldAlertController() {
        
        let textFieldAlert: TextFieldAlert
        
        switch alertType {
        case .textFieldAlert(let type):
            textFieldAlert = type
        case .defaultAlert:
            return
        }
        
        let title = "Изменение фото"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Вставьте ссылку на фото"
        }
        
        let actionSave = UIAlertAction(title: "Сохранить", style: .default) { action in
            
            guard
                let textField = alert.textFields?.first,
                let text = textField.text 
            else { return }
            
            textFieldAlert.delegate.alertSaveButtonTappep(text: text)
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(actionCancel)
        alert.addAction(actionSave)
        
        textFieldAlert.viewController.present(alert, animated: true)
    }
}
