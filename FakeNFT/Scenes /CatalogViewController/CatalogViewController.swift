import UIKit

final class CatalogViewController: UIViewController {

    // MARK: - Private Properties

    private let servicesAssembly: ServicesAssembly

    internal let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    private var nftsCollection: [CollectionNftModel] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 179
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(CatalogViewCell.self, forCellReuseIdentifier: "CatalogViewCell")
        tableView.separatorStyle = .none
        return tableView
    }()

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
        setupActivityIndicator()
        loadCollection()
    }

    // MARK: - Private Methods

    private func setupNavBar() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "sortButtonImage"),
            style: .plain,
            target: self,
            action: #selector(didTapButton)
        )

        let backButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        backButton.tintColor = .black

        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    @objc
    private func didTapButton() {
        let alertController = UIAlertController(
            title: nil,
            message: NSLocalizedString("Catalog.alertTitle", comment: ""),
            preferredStyle: .actionSheet
        )

        let nameSort = UIAlertAction(
            title: NSLocalizedString("Catalog.alertFirstButton", comment: ""),
            style: .default
        ) { _ in
            print("1")
        }

        let countSort = UIAlertAction(
            title: NSLocalizedString("Catalog.alertSecondButton", comment: ""),
            style: .default
        ) { _ in
            print("2")
        }

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Catalog.alertCancelButton", comment: ""),
            style: .cancel
        )

        alertController.addAction(nameSort)
        alertController.addAction(countSort)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }

    private func loadCollection() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        servicesAssembly.collectionService.loadCollection { result in

            switch result {
            case .success(let collectionNft):
                self.nftsCollection = collectionNft
                self.setupTableView()
            case .failure(let error):
                print("Error loading collection: \(error)")
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.isSelected = false
        navigationController?.pushViewController(CollectionViewController(), animated: true)
    }

}

// MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nftsCollection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogViewCell") as? CatalogViewCell

        guard let cell = cell,
              !nftsCollection.isEmpty else { return UITableViewCell()}

        var currentCollection = nftsCollection[indexPath.row]

        let catalog = CatalogModel(
            name: currentCollection.name,
            imageUrl: currentCollection.cover,
            count: currentCollection.nfts.count
        )

        cell.configure(catalog: catalog)

        return cell
    }
}

// MARK: - LoadingView

extension CatalogViewController: LoadingView {

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
    }
}
