//
//  TableViewCell.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 15.06.2024.
//

import UIKit

final class ProfileTableCell: UITableViewCell {
    
    let cellTextLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell(){
        
        cellTextLabel.font = UIFont.bodyBold
        cellTextLabel.numberOfLines = 2
        cellTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellTextLabel)
        
        NSLayoutConstraint.activate([
            cellTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56)
        ])
    }
}
