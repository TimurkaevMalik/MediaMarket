//
//  RedactingViewController.swift
//  FakeNFT
//
//  Created by Malik Timurkaev on 15.06.2024.
//

import UIKit

final class RedactingViewController: UIViewController {
    
    private lazy var nameTitleLabel = UILabel()
    private lazy var nameTextField = UITextField()
    private let clearTextFieldButton = UIButton(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    
    private lazy var userPhotoButton = UIButton()
    private lazy var userPhotoTitleLabel = UILabel()
    
    private let warningLabel = UILabel()
    private let warningLabelContainer = UIView()
    
    private var alertPresenter: AlertPresenter?
    
    private var warningLabelBottomConstraint: [NSLayoutConstraint] = []
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let alertType = AlertType.textFieldAlert(value: TextFieldAlert(viewController: self, delegate: self))
        alertPresenter = AlertPresenter(type: alertType)
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
    }
    
    @objc func userPhotoButtonTapped() {
        print("user photo button tapped")
        
        alertPresenter?.textFieldAlertController()
    }
    
    @objc func clearTextFieldButtonTapped(){
        nameTextField.text?.removeAll()
    }
    
    @objc func didEnterNameInTextField(_ sender: UITextField){
        
        guard
            let text = sender.text,
            !text.isEmpty,
            !text.filter({ $0 != Character(" ") }).isEmpty
        else {
        
            let warningText = "Не удалось сохранить имя"
            clearTextFieldButtonTapped()
            showWarningLabel(with: warningText)
            return
        }
        
        nameTextField.text = text.trimmingCharacters(in: .whitespaces)
        saveUserInfo(text)
    }
    
    private func configureUserPhoto() {
        let image = UIImage(named: "avatarPlug")
        let title = "Сменить \n фото"
        userPhotoButton.tintColor = .clear
        userPhotoButton.setImage(image, for: .normal)
        
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
            
            userPhotoTitleLabel.centerXAnchor.constraint(equalTo: userPhotoButton.centerXAnchor),
            userPhotoTitleLabel.centerYAnchor.constraint(equalTo: userPhotoButton.centerYAnchor)
        ])
    }
    
    private func configureNameTitleAndTextField(){
        nameTitleLabel.textColor = .ypBlack
        nameTextField.backgroundColor = UIColor(named: "YPMediumLightGray")
        clearTextFieldButton.backgroundColor = UIColor(named: "YPMediumLightGray")
        
        nameTitleLabel.text = "Имя"
        nameTitleLabel.font = UIFont.headline3
        
        nameTextField.placeholder = "Введите фамилию и имя"
        nameTextField.delegate = self
        nameTextField.layer.cornerRadius = 16
        nameTextField.layer.masksToBounds = true
        nameTextField.leftViewMode = .always
        
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameTextField.addTarget(self, action: #selector(didEnterNameInTextField(_:)), for: .editingDidEndOnExit)
        nameTextField.rightView = clearTextFieldButton
        nameTextField.rightViewMode = .whileEditing
        
        clearTextFieldButton.contentHorizontalAlignment = .leading
        clearTextFieldButton.addTarget(self, action: #selector(clearTextFieldButtonTapped), for: .touchUpInside)
        clearTextFieldButton.setImage(UIImage(named: "x.mark.circle"), for: .normal)
        
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
            
            clearTextFieldButton.widthAnchor.constraint(equalToConstant: clearTextFieldButton.frame.width + 12)
        ])
    }
    
    private func configureLimitWarningLabel(){
        warningLabelContainer.backgroundColor = UIColor.ypWhite
        warningLabel.textColor = UIColor(named: "YPRed")
        warningLabel.font = UIFont.systemFont(ofSize: 17)
        
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
    }
    
    private func saveUserInfo(_ text: String) {
        let name = text.trimmingCharacters(in: .whitespaces)
        print(name)
    }
}

extension RedactingViewController: AlertDelegateProtocol {
    func alertSaveButtonTappep(text: String?) {
        
        guard
            let text = text,
            !text.filter({$0 != Character(" ")}).isEmpty 
        else {
            alertPresenter?.textFieldAlertController()
            showWarningLabel(with: "Не удалось сохранить фото")
            return
        }
        print(text)
    }
}

extension RedactingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 38
        
        let currentString = (textField.text ?? "") as NSString
        
        let newString = currentString.replacingCharacters(in: range, with: string).trimmingCharacters(in: .newlines)
        
        guard newString.count <= maxLength else {
            
            let limititationText = NSLocalizedString("warning.limititation", comment: "Text before the number of the limit")
            let charatersText = NSLocalizedString("warning.caracters", comment: "Text after the number of the limit")
            
            showWarningLabel(with: limititationText + " \(38) " + charatersText)
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        didEnterNameInTextField(textField)
    }
}
