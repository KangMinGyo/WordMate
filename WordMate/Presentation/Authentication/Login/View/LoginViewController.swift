//
//  LoginViewController.swift
//  WordMate
//
//  Created by KangMingyo on 1/9/25.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "WordMateLogo")
    }
    
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
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.primaryOrange, for: .normal)
        $0.setTitleColor(.buttonTextEnabled, for: .disabled)
        $0.backgroundColor = .buttonEnabled
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.snp.makeConstraints { $0.height.equalTo(50) }
        $0.isEnabled = false
    }
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("회원이 아니신가요? ", "회원가입")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
        setupView()
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { result in
            switch result {
            case .success(let authData):
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                guard let window = windowScene?.windows.first(where: { $0.isKeyWindow }) else {
                return }
                 
                guard let tab = window.rootViewController as? MainTabBarController else { return }
                tab.authenticateUserAndSetupUI()
                
                self.dismiss(animated: true, completion: nil)
                print("User logged in successfully! UID: \(authData.user.uid)")
            case .failure(let error):
                print("Failed to log in user: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func updateLoginButtonState(isWordValid: Bool, isMeaningValid: Bool) {
        loginButton.isEnabled = isWordValid && isMeaningValid
        loginButton.backgroundColor = (isWordValid && isMeaningValid) ? .white : .buttonEnabled
    }
    
    // MARK: - Helpers
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    }
    
    func setupView() {
        view.backgroundColor = .primaryOrange
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(150)
        }
        
        let stackView = Utilities().createStackView(with: [emailContainerView, passwordContainerView, loginButton])
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        DispatchQueue.main.async { [self] in
            if textField == emailTextField {
                let isWordValid = !updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isMeaningValid = !(passwordTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                updateLoginButtonState(isWordValid: isWordValid, isMeaningValid: isMeaningValid)
            } else if textField == passwordTextField {
                let isWordValid = !(emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isMeaningValid = !updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.updateLoginButtonState(isWordValid: isWordValid, isMeaningValid: isMeaningValid)
            }
        }
        return true
    }
}
