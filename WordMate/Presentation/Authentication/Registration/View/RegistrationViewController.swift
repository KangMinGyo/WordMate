//
//  RegistrationViewController.swift
//  WordMate
//
//  Created by KangMingyo on 1/9/25.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: - Properties

    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "envelope")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()

    private lazy var userNameContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(withImage: image, textField: userNameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        tf.textContentType = .oneTimeCode
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "User Name")
        return tf
    }()
    
    private let signUpButton = UIButton().then {
        $0.setTitle("Sign Up", for: .normal)
        $0.setTitleColor(.primaryOrange, for: .normal)
        $0.setTitleColor(.buttonTextEnabled, for: .disabled)
        $0.backgroundColor = .buttonEnabled
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.snp.makeConstraints { $0.height.equalTo(50) }
        $0.isEnabled = false
    }
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("이미 회원이신가요? ", "로그인")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupView()
    }
    
    // MARK: - Selectors

    @objc private func handleRegistration() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        let credentials = AuthCredentials(email: email, password: password, userName: userName)
        registrationUser(credentials: credentials)
    }
    
    private func registrationUser(credentials: AuthCredentials) {
        AuthService.shared.registerUser(credentials: credentials) { result in
            switch result {
            case .success:
                self.handleRegistrationSuccess()
            case .failure(let error):
                self.handleRegistrationFailed(error)
            }
        }
    }
    
    private func handleRegistrationSuccess() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first(where: { $0.isKeyWindow }) else { return }
        guard let tab = window.rootViewController as? MainTabBarController else { return }
        
        tab.authenticateUserAndSetupUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func handleRegistrationFailed(_ error: Error) {
        print("Failed to log in user: \(error.localizedDescription)")
    }
    
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateSignupButtonState(isWordValid: Bool, isMeaningValid: Bool) {
        signUpButton.isEnabled = isWordValid && isMeaningValid
        signUpButton.backgroundColor = (isWordValid && isMeaningValid) ? .white : .buttonEnabled
    }
    
    // MARK: - Helpers
    
    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        alreadyHaveAccountButton.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    }
    
    private func setupView() {
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.backgroundColor = .primaryOrange
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        let stackView = Utilities().createStackView(with: [emailContainerView, passwordContainerView, userNameContainerView, signUpButton])
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        DispatchQueue.main.async { [self] in
            if textField == emailTextField {
                let isWordValid = !updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isMeaningValid = !(passwordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                updateSignupButtonState(isWordValid: isWordValid, isMeaningValid: isMeaningValid)
            } else if textField == passwordTextField {
                let isWordValid = !(emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isMeaningValid = !updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.updateSignupButtonState(isWordValid: isWordValid, isMeaningValid: isMeaningValid)
            }
        }
        return true
    }
}
