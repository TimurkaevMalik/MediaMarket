//
//  DeleteNftFromCartViewController.swift
//  FakeNFT
//
//  Created by Олег Спиридонов on 15.06.2024.
//

import Foundation
import UIKit

protocol DeleteNftFromCartViewControllerDelegate: AnyObject {
    func turnOffBlurEffect()
    func deleteNft(nftModel: NftInCartModel)
}

final class DeleteNftFromCartViewController: UIViewController {

    // MARK: - Public Properties

    var nftModel: NftInCartModel?
    weak var delegate: DeleteNftFromCartViewControllerDelegate?

    // MARK: - Private Properties

    private let nftImageView = UIImageView()
    private let textLable = UILabel()
    private let deleteButton = UIButton()
    private let cancelButton = UIButton()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Private Methods

    private func setupViews() {
        addTextLable()
        addDeleteButton()
        addCancelButton()
        if let imageStr = nftModel?.picture {
            addNftImageView(imageStr: imageStr)
        }
    }

    private func addTextLable() {
        textLable.text = "Вы уверены, что хотите удалить объект из корзины?"
        textLable.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textLable.textColor = UIColor(named: "YPBlack")
        textLable.numberOfLines = 2
        textLable.textAlignment = .center
        textLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLable)
        NSLayoutConstraint.activate([
            textLable.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            textLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLable.widthAnchor.constraint(equalToConstant: 180)
        ])
    }

    private func addNftImageView(imageStr: String) {
        guard let url = URL(string: imageStr) else { return }
        nftImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        nftImageView.layer.masksToBounds = true
        nftImageView.layer.cornerRadius = 12
        view.addSubview(nftImageView)
        NSLayoutConstraint.activate([
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: textLable.topAnchor, constant: -12),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)
        ])
    }

    private func setupButton(name: String, color: UIColor, button: UIButton) {
        button.setTitle(name, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = UIColor(named: "YPBlack")
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 12
    }

    private func addDeleteButton() {
        guard let color = UIColor(named: "YPRed") else { return }
        setupButton(name: "Удалить", color: color, button: deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonTap), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            deleteButton.topAnchor.constraint(equalTo: view.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func addCancelButton() {
        guard let color = UIColor(named: "YPWhite") else { return }
        setupButton(name: "Вернуться", color: color, button: cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            cancelButton.topAnchor.constraint(equalTo: view.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Private Actions

    @objc private func cancelButtonTap() {
        delegate?.turnOffBlurEffect()
        self.dismiss(animated: false)
    }

    @objc private func deleteButtonTap() {
        guard let nftModel else { return }
        delegate?.deleteNft(nftModel: nftModel)
        delegate?.turnOffBlurEffect()
        self.dismiss(animated: true)
    }
}
