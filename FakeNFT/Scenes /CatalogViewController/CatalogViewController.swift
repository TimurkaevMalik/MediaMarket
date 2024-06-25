import UIKit

final class CatalogViewController: UIViewController {

    // MARK: - Public Properties

    let servicesAssembly: ServicesAssembly

    // MARK: - Private Properties

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
        setupTableView()
    }

    // MARK: - Public Methods

    // MARK: - Private Methods

    private func setupNavBar() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "sortButtonImage"),
            style: .plain,
            target: self,
            action: #selector(didTapButton)
        )
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
}

// MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogViewCell") as? CatalogViewCell

        guard let cell = cell else { return UITableViewCell()}

        let catalog = CatalogModel(
            name: "Peach",
            cover: UIImage(named: "White") ?? UIImage(),
            count: indexPath.row
        )

        cell.configure(catalog: catalog)

        return cell
    }
}
