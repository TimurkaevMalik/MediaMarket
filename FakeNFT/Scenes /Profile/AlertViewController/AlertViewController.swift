//
//  AlertViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 16.06.2024.
//

import UIKit


final class AlertPresenter {
    
    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
   
    func textFieldAlert(model: AlertModel, placeHolder: String, delegate: TextFieldAlertDelegate) {

        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = placeHolder
        }
        
        let actionSave = UIAlertAction(title: model.completionTitle, style: .default) { action in
            
            guard
                let textField = alert.textFields?.first,
                let text = textField.text 
            else { return }
            
            delegate.alertSaveTextButtonTappep(text: text)
        }
        
        let actionCancel = UIAlertAction(title: model.closeAlertTitle, style: .destructive)
        
        alert.addAction(actionCancel)
        alert.addAction(actionSave)
        
        viewController.present(alert, animated: true)
    }
    
    func defaultAlert(model: AlertModel) {
        
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        
        let actionCloseAlert = UIAlertAction(title: model.closeAlertTitle, style: .default)
        
        let actionCallMethod = UIAlertAction(title: model.completionTitle, style: .default) { _ in
            
            model.completion()
        }
        
        alert.addAction(actionCallMethod)
        alert.addAction(actionCloseAlert)
        
        viewController.present(alert, animated: true)
    }
}
