import UIKit

final class CatalogViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        return coverImageView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 17)
        nameLabel.textColor = .black
        return nameLabel
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "CatalogViewCell")
        self.backgroundColor = .systemBackground
        setupCover()
        setupName()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(catalog: CatalogModel) {
        coverImageView.image = catalog.cover
        nameLabel.text = "\(catalog.name) (\(catalog.count))"
    }

    // MARK: - Private Methods

    private func setupCover() {
        contentView.addSubview(coverImageView)

        coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        coverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant: 343).isActive = true
    }

    private func setupName() {
        contentView.addSubview(nameLabel)

        nameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 4).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 343).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
}
