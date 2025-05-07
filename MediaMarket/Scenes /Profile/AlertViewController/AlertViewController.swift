//
//  AlertViewController.swift
//  MediaMarket
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

        let actionSave = UIAlertAction(title: model.completionTitle, style: .default) { _ in

            guard
                let textField = alert.textFields?.first
            else { return }

            delegate.alertSaveTextButtonTappep(text: textField.text)
        }

        let actionCancel = UIAlertAction(title: model.closeAlertTitle, style: .destructive)

        alert.addAction(actionSave)
        alert.addAction(actionCancel)

        viewController.present(alert, animated: true)
    }

    func defaultAlert(model: AlertModel) {

        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)

        let actionCancel = UIAlertAction(title: model.closeAlertTitle, style: .default)

        let actionCallMethod = UIAlertAction(title: model.completionTitle, style: .default) { _ in

            model.completion()
        }

        alert.addAction(actionCallMethod)
        alert.addAction(actionCancel)

        viewController.present(alert, animated: true)
    }

    func sortionAlert(delegate: SortAlertDelegate) {

        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .ypBlue

        let sortByPrice = UIAlertAction(title: "По цене", style: .default) { _ in
            delegate.sortByPrice()
        }

        let sortByRate = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            delegate.sortByRate()
        }

        let sortByName = UIAlertAction(title: "По названию", style: .default) { _ in
            delegate.sortByName()
        }

        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)

        alert.addAction(sortByPrice)
        alert.addAction(sortByRate)
        alert.addAction(sortByName)
        alert.addAction(closeAction)

        viewController.present(alert, animated: true)
    }

    func fetchNFTAlert(title: String, delegate: FetchNFTAlertDelegate) {

        let message = "Не удалось получить" + "\n" + "следующий NFT"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let actionCancel = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            delegate.closeActionTapped()
        }

        let actionTryAgain = UIAlertAction(title: "повторить", style: .default) { _ in
            delegate.tryToReloadNFT()
        }

        let actionLoadRest = UIAlertAction(title: "пропустить", style: .default) { _ in
            delegate.loadRestOfNFT()
        }

        alert.addAction(actionCancel)
        alert.addAction(actionTryAgain)
        alert.addAction(actionLoadRest)

        viewController.present(alert, animated: true)
    }
}
