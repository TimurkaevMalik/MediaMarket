//
//  UIBlockingProgressHUD.swift
//  MediaMarket
//
//  Created by Malik Timurkaev on 17.06.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {

    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
}
