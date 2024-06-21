import UIKit

final class CatalogViewController: UIViewController {

    // MARK: - Public Properties

    let servicesAssembly: ServicesAssembly

    // MARK: - Private Properties

    // MARK: - Initializers

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBar()
    }

    // MARK: - Public Methods

    // MARK: - Private Methods

    private func setupNavBar() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "sort.icon"),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
}
