//
//  RedactingViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 15.06.2024.
//

import UIKit

final class RedactingViewController: UIViewController {
    
    private weak var delegate: ProfileControllerDelegate?
    
    private lazy var nameTitleLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private let clearNameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
    private lazy var linkTitleLabel = UILabel()
    private lazy var linkTextField = UITextField()
    private let clearLinkButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
    private lazy var descriptionTitleLabel = UILabel()
    private lazy var userDescriptionView = UITextView()
    
    private lazy var userPhotoButton = UIButton()
    private lazy var userPhotoTitleLabel = UILabel()
    
    private lazy var closeControllerButton = UIButton()
    private let warningLabel = UILabel()
    private let warningLabelContainer = UIView()
    
    private var alertPresenter: AlertPresenter?
    private var profileInfo: Profile
    private let fetchProfileService = FetchProfileService.shared
    
    private var warningLabelBottomConstraint: [NSLayoutConstraint] = []
    private let descriptionViewPlaceholder = "Расскажите о себе"
    
    
    init(profile: Profile, delegate: ProfileControllerDelegate) {
        profileInfo = profile
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)

        alertPresenter = AlertPresenter(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureUserPhoto()
        configureLimitWarningLabel()
        configureNameTitleAndTextField()
        configureUserDescriptionViewAndTitle()
        configureLinkTitleAndTextField()
        configureCloseControllerButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileInfo(profileInfo)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didEndRedactingProfile(profileInfo)
    }
    
    @objc func closeControllerButtonTapper() {
        dismiss(animated: true)
    }
    
    @objc func userPhotoButtonTapped() {
        showTextFieldAlert(message: nil)
    }
    
    @objc func clearNameButtonTapped(){
        nameTextField.text?.removeAll()
        profileInfo.name.removeAll()
    }
    
    @objc func clearLinkButtonTapped(){
        linkTextField.text?.removeAll()
        profileInfo.website.removeAll()
    }
    
    @objc func didEnterNameInTextField(_ sender: UITextField){
        
        guard
            let name = sender.text?.trimmingCharacters(in: .whitespaces),
            !name.isEmpty,
            !name.filter({ $0 != Character(" ") }).isEmpty
        else {
            
            let warningText = "Введите имя и фамилию"
            clearNameButtonTapped()
            showWarningLabel(with: warningText)
            profileInfo.name.removeAll()
            return
        }
        
        nameTextField.text = name
        profileInfo.name = name
    }
    
    @objc func didEnterLinkInTextField(_ sender: UITextField){
        
        guard
            let link = sender.text?.trimmingCharacters(in: .whitespaces),
            !link.isEmpty,
            !link.filter({ $0 != Character(" ") }).isEmpty
        else {
            
            let warningText = "Введите ссылку"
            clearLinkButtonTapped()
            showWarningLabel(with: warningText)
            profileInfo.website.removeAll()
            return
        }
        
        linkTextField.text = link
        profileInfo.website = link
    }
    
    private func configureCloseControllerButton() {
        let image = UIImage(named: "close")
        closeControllerButton.tintColor = .ypBlack
        
        closeControllerButton.setImage(image, for: .normal)
        closeControllerButton.addTarget(self, action: #selector(closeControllerButtonTapper), for: .touchUpInside)
        
        closeControllerButton.addTarget(self, action: #selector(userPhotoButtonTapped), for: .touchUpInside)
        closeControllerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeControllerButton)
        
        NSLayoutConstraint.activate([
            closeControllerButton.widthAnchor.constraint(equalToConstant: 42),
            closeControllerButton.heightAnchor.constraint(equalToConstant: 42),
            closeControllerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -694),
            closeControllerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureUserPhoto() {
        let image = UIImage(named: "avatarPlug")
        let title = "Поиск \n фото"
        userPhotoButton.tintColor = .clear
        userPhotoButton.setImage(image, for: .normal)
        userPhotoTitleLabel.backgroundColor = .black.withAlphaComponent(0.6)
        
        userPhotoTitleLabel.text = title
        userPhotoTitleLabel.numberOfLines = 2
        userPhotoTitleLabel.textColor = .white
        userPhotoTitleLabel.textAlignment = .center
        userPhotoTitleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        userPhotoButton.layer.masksToBounds = true
        userPhotoButton.layer.cornerRadius = 35
        userPhotoButton.clipsToBounds = true
        userPhotoButton.contentMode = .scaleAspectFill
        
        userPhotoButton.addTarget(self, action: #selector(userPhotoButtonTapped), for: .touchUpInside)
        userPhotoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhotoButton)
        userPhotoButton.addSubview(userPhotoTitleLabel)
        
        NSLayoutConstraint.activate([
            userPhotoButton.widthAnchor.constraint(equalToConstant: 70),
            userPhotoButton.heightAnchor.constraint(equalToConstant: 70),
            userPhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -602),
            userPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userPhotoTitleLabel.topAnchor.constraint(equalTo: userPhotoButton.topAnchor),
            userPhotoTitleLabel.bottomAnchor.constraint(equalTo: userPhotoButton.bottomAnchor),
            userPhotoTitleLabel.leadingAnchor.constraint(equalTo: userPhotoButton.leadingAnchor),
            userPhotoTitleLabel.trailingAnchor.constraint(equalTo: userPhotoButton.trailingAnchor)
        ])
    }
    
    private func configureNameTitleAndTextField(){
        nameTitleLabel.textColor = .ypBlack
        nameTextField.backgroundColor = UIColor(named: "YPMediumLightGray")
        clearNameButton.backgroundColor = UIColor(named: "YPMediumLightGray")
        
        nameTitleLabel.text = "Имя"
        nameTitleLabel.font = UIFont.headline3
        
        nameTextField.placeholder = "Введите имя и фамилию"
        nameTextField.text = "Поиск имени и фамилии"
        nameTextField.delegate = self
        nameTextField.layer.cornerRadius = 16
        nameTextField.layer.masksToBounds = true
        nameTextField.leftViewMode = .always
        
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameTextField.addTarget(self, action: #selector(didEnterNameInTextField(_:)), for: .editingDidEndOnExit)
        nameTextField.addTarget(self, action: #selector(didEnterNameInTextField(_:)), for: .editingDidEnd)
        nameTextField.rightView = clearNameButton
        nameTextField.rightViewMode = .whileEditing
        
        clearNameButton.contentHorizontalAlignment = .leading
        clearNameButton.addTarget(self, action: #selector(clearNameButtonTapped), for: .touchUpInside)
        clearNameButton.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        view.addSubview(nameTitleLabel)
        
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: userPhotoButton.bottomAnchor, constant: 24),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            clearNameButton.widthAnchor.constraint(equalToConstant: clearNameButton.frame.width + 12)
        ])
    }
    
    private func configureLinkTitleAndTextField(){
        linkTitleLabel.textColor = .ypBlack
        linkTextField.backgroundColor = UIColor(named: "YPMediumLightGray")
        clearLinkButton.backgroundColor = UIColor(named: "YPMediumLightGray")
        
        linkTitleLabel.text = "Сайт"
        linkTitleLabel.font = UIFont.headline3
        
        linkTextField.placeholder = "Введите ссылку"
        linkTextField.text = "Поиск ссылки сайта"
        linkTextField.delegate = self
        linkTextField.layer.cornerRadius = 16
        linkTextField.layer.masksToBounds = true
        linkTextField.leftViewMode = .always
        
        linkTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        linkTextField.addTarget(self, action: #selector(didEnterLinkInTextField(_:)), for: .editingDidEndOnExit)
        linkTextField.addTarget(self, action: #selector(didEnterLinkInTextField(_:)), for: .editingDidEnd)
        linkTextField.rightView = clearLinkButton
        linkTextField.rightViewMode = .whileEditing
        
        clearLinkButton.contentHorizontalAlignment = .leading
        clearLinkButton.addTarget(self, action: #selector(clearLinkButtonTapped), for: .touchUpInside)
        clearLinkButton.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        
        linkTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        linkTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(linkTextField)
        view.addSubview(linkTitleLabel)
        
        NSLayoutConstraint.activate([
            linkTitleLabel.topAnchor.constraint(equalTo: userDescriptionView.bottomAnchor, constant: 24),
            linkTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            linkTextField.heightAnchor.constraint(equalToConstant: 44),
            linkTextField.topAnchor.constraint(equalTo: linkTitleLabel.bottomAnchor, constant: 8),
            linkTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            linkTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            clearLinkButton.widthAnchor.constraint(equalToConstant: clearLinkButton.frame.width + 12)
        ])
    }
    
    private func configureUserDescriptionViewAndTitle() {
        descriptionTitleLabel.textColor = .ypBlack
        userDescriptionView.backgroundColor = UIColor(named: "YPMediumLightGray")
        userDescriptionView.delegate = self
        userDescriptionView.isScrollEnabled = false
        
        descriptionTitleLabel.text = "Описание"
        descriptionTitleLabel.font = .headline3
        
        userDescriptionView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: -11, right: -16)
        userDescriptionView.layer.masksToBounds = true
        userDescriptionView.layer.cornerRadius = 12
        userDescriptionView.textAlignment = .left
        userDescriptionView.textContainer.maximumNumberOfLines = 5
        
        let text = "Поиск описания"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing =  3
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          .foregroundColor: UIColor.ypBlack,
                          .font: UIFont.bodyRegular
        ]
        
        userDescriptionView.attributedText = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        
        view.addSubview(userDescriptionView)
        view.addSubview(descriptionTitleLabel)
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            userDescriptionView.heightAnchor.constraint(equalToConstant: 132),
            userDescriptionView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            userDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLimitWarningLabel(){
        warningLabelContainer.backgroundColor = UIColor.ypWhite
        warningLabel.textColor = UIColor(named: "YPRed")
        warningLabel.font = UIFont.systemFont(ofSize: 17)
        warningLabel.numberOfLines = 2
        warningLabel.textAlignment = .center
        
        view.addSubview(warningLabel)
        view.addSubview(warningLabelContainer)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            warningLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            warningLabelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            warningLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let constraint = warningLabel.topAnchor.constraint(equalTo: warningLabelContainer.topAnchor)
        
        warningLabelBottomConstraint.append(constraint)
        
        warningLabelBottomConstraint.first?.isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func showWarningLabel(with text: String){
        
        warningLabel.text = text
        isTextFieldAndSaveButtonEnabled(bool: false)
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.5, delay: 0.03) {
                self.warningLabelBottomConstraint.first?.constant = -50
                self.view.layoutIfNeeded()
                
            } completion: { isCompleted in
                
                UIView.animate(withDuration: 0.4, delay: 2) {
                    self.warningLabelBottomConstraint.first?.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.1, execute: {
            
            self.isTextFieldAndSaveButtonEnabled(bool: true)
        })
    }
    
    private func isTextFieldAndSaveButtonEnabled(bool: Bool){
        userPhotoButton.isEnabled = bool
        nameTextField.isEnabled = bool
        userDescriptionView.isEditable = bool
    }
    
    
    private func clearTextView() {
        userDescriptionView.text = "Расскажите о себе"
        userDescriptionView.textColor = UIColor.lightGray
        profileInfo.description.removeAll()
    }
    
    func updateProfileInfo(_ profile: Profile) {
        nameTextField.text = profile.name
        linkTextField.text = profile.website
        
        updateUserPhotoWith(url: profile.avatar)
        updateUserDescription(profile.description)
    }
    
    private func updateUserDescription(_ description: String?) {
        userDescriptionView.text = description
        textViewDidEndEditing(userDescriptionView)
    }
    
    private func updateUserPhotoWith(url: String) {
        let title = "Сменить \n фото"
        userPhotoTitleLabel.text = title
        
        guard let avatarUrl = URL(string: url) else {
            return
        }
        
        userPhotoButton.imageView?.kf.setImage(with: avatarUrl) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
                
            case .success(let value):
                self.profileInfo.avatar = url
                userPhotoButton.setImage(value.image, for: .normal)
                
            case .failure(let error):
                self.showTextFieldAlert(message: "\n Ошибка: \(error.errorCode)")
                self.showWarningLabel(with: "Не удалось определить." + "\n" + "Попробуйте другую ссылку")
                return
            }
        }
    }
    
    private func showTextFieldAlert(message: String?) {
        let placeHolder = "Введите ссылку"
        let model = AlertModel(
            title: "Изменение фото", message: message,
            closeAlertTitle: "Отмена",
            completionTitle: "Сохранить") {}
        
        alertPresenter?.textFieldAlert(model: model, placeHolder: placeHolder, delegate: self)
    }
}

extension RedactingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 38
        
        let currentString = (textField.text ?? "") as NSString
        
        let newString = currentString.replacingCharacters(in: range, with: string).trimmingCharacters(in: .newlines)
        
        guard newString.count <= maxLength else {
            
            showWarningLabel(with: "Ограничение \(38) слов")
            return false
        }
        
        return true
    }
}

extension RedactingViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let maxLength = 140
        
        let currentString = (textView.text ?? "") as NSString
        
        let newString = currentString.replacingCharacters(in: range, with: text).trimmingCharacters(in: .newlines)
        
        guard newString.count <= maxLength else {
            return false
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let description = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            !description.isEmpty,
            !description.filter({ $0 != Character(" ") }).isEmpty
        else {
        
            clearTextView()
            return
        }
        
        textView.text = description
        profileInfo.description = description
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let text = textView.text,
           text == descriptionViewPlaceholder {
            textView.text.removeAll()
        }
        
        textView.textColor = .ypBlack
    }
}

extension RedactingViewController: TextFieldAlertDelegate {
    
    func alertSaveTextButtonTappep(text: String?) {
        
        guard
            let link = text?.trimmingCharacters(in: .whitespaces),
            !link.filter({$0 != Character(" ")}).isEmpty
        else {
            showTextFieldAlert(message: nil)
            showWarningLabel(with: "Введите ссылку")
            return
        }
        updateUserPhotoWith(url: link)
    }
}
