import Foundation
import UIKit


final class UserCardTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    private let numberNftLabel = UILabel()
    private let title = NSLocalizedString("Statistic.userCard.nft", comment: "")
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        self.backgroundColor = UIColor(named: "YPWhite")
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        setupTitleLabel()
        setupNumberNftLabel()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateNumberNftLabel(text: String){
        numberNftLabel.text = "(\(text))"
    }
    
    // MARK: - Private Methods
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
    }
    
    private func setupNumberNftLabel() {
        contentView.addSubview(numberNftLabel)
        numberNftLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        numberNftLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            numberNftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberNftLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
        ])
    }
}
