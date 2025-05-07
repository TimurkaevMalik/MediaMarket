//
//  UserAgreementViewController.swift
//  MediaMarket
//
//  Created by Олег Спиридонов on 24.06.2024.
//

import Foundation
import WebKit
import ProgressHUD

final class UserAgreementViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Private Properties

    private let webView = WKWebView()
    private let url = "https://yandex.ru/legal/practicum_termsofuse/"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }

    // MARK: - Public Methods

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            ProgressHUD.show()
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            ProgressHUD.dismiss()
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            ProgressHUD.dismiss()
            showAlertWith(title: "Ошибка загрузки", message: error.localizedDescription)
        }

    // MARK: - Private Methods

    private func setupViews() {
        addWebView()
        setupWebView()
    }

    private func addWebView() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    private func setupWebView() {
        if let url = URL(string: self.url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    private func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let backAction = UIAlertAction(title: "Вернутся", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        alertController.addAction(backAction)
        present(alertController, animated: true, completion: nil)
    }
}
