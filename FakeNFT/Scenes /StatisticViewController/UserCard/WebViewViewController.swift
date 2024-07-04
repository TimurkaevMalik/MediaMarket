import Foundation
import WebKit
import UIKit
import ProgressHUD


final class WebViewViewController: UIViewController {
    // MARK: - Private Properties
    private let webView = WKWebView()
    private var website = String()
    private let errorLabel = UILabel()
    private let errorText = NSLocalizedString("Statistic.userCard.error", comment: "")
    
    // MARK: - Initializers
    init(website: String) {
        super.init(nibName: nil, bundle: nil)
        self.website = website
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        ProgressHUD.show()
        setupNavBar()
        setupWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
        ProgressHUD.dismiss()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            ProgressHUD.dismiss()
        } else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
        }
    }
    
    // MARK: - Actions
    @objc private func onClickBackButton() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func setupNavBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(onClickBackButton))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func showError() {
        ProgressHUD.dismiss()
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = errorText
        errorLabel.font = UIFont.systemFont(ofSize: 25)
        setupConstraint()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.frame = CGRect(x: 0, y: 95, width: view.frame.width, height: view.frame.height)
        webView.allowsBackForwardNavigationGestures = true
        guard let url = URL(string: website) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.showError()
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    DispatchQueue.main.async {
                        self.webView.load(URLRequest(url: url))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showError()
                }
            }
        }
        task.resume()
        
    }
}
