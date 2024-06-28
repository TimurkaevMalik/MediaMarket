//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 28.06.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private lazy var webView = WKWebView()
    
    private let webViewURL: URL
    
    init(webViewURL: URL) {
        self.webViewURL = webViewURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureWebView()
    }
    
    private func configureWebView() {
        webView.backgroundColor = .ypWhite
        
        let request = URLRequest(url: webViewURL)
        webView.load(request)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
