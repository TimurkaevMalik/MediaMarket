//
//  PaymentVC + extention.swift
//  MediaMarket
//
//  Created by Олег Спиридонов on 20.06.2024.
//

import Foundation
import UIKit

// MARK: - UICollectionViewDelegate

extension PaymentViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PaymentMethodeCell {
            cell.selectCell()
            self.selectedPaymentMethode = cell.paymentMethodModel
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PaymentMethodeCell {
            cell.deselectCell()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PaymentViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentMethods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PaymentMethodeCell else { return UICollectionViewCell() }
        cell.setupCell(paymentMethodModel: paymentMethods[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PaymentViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
                    return CGSize(width: 168, height: 46)
                }
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing) / 2
        let itemHeight: CGFloat = 46
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
