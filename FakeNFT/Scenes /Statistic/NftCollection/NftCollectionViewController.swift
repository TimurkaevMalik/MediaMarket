import Foundation
import UIKit
import ProgressHUD


final class NftCollectionViewController: UIViewController {
    // MARK: - Private Properties
    private var nfts = [String]()
    
    // MARK: - Initializers
    init(nfts: [String]) {
        self.nfts = nfts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        setupNavBar()
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
}
