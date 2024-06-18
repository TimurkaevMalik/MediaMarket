//
//  AlertViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 16.06.2024.
//

import UIKit


final class AlertPresenter {
    
    let alertType: AlertType
    
    init(type: AlertType) {
        alertType = type
    }
   
    func textFieldAlert() {
        
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
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alert.addAction(actionCancel)
        alert.addAction(actionSave)
        
        textFieldAlert.viewController.present(alert, animated: true)
    }
    
    func defaultAlert(model: DefaultAlertModel) {
        
        let delegate: DefaultAlertDelegate
        
        switch alertType {
        case .textFieldAlert:
            return
        case .defaultAlert(let type):
            delegate = type
        }
        
        let title = "Ошибка обновления профиля"
        
        let alert = UIAlertController(title: title, message: model.message, preferredStyle: .alert)
        
        let actionCloseAlert = UIAlertAction(title: model.closeAlertTitle, style: .default)
        
        let actionCallMethod = UIAlertAction(title: model.callMethodTitle, style: .default) { [weak self] _ in
            
            guard let self else { return }
            
            delegate.callMethodActionTapped()
        }
        
        alert.addAction(actionCallMethod)
        alert.addAction(actionCloseAlert)
        
        delegate.present(alert, animated: true)
    }
}
