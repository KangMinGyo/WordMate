//
//  RegistrationViewController.swift
//  WordMate
//
//  Created by KangMingyo on 1/9/25.
//

import UIKit

class RegistrationViewController: UIViewController {
    
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
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "User Name")
        return tf
    }()
    
    private let signUpButton = UIButton().then {
        $0.setTitle("Sign Up", for: .normal)
        $0.setTitleColor(.primaryOrange, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.snp.makeConstraints { $0.height.equalTo(50) }
    }
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("이미 회원이신가요? ", "로그인")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        configureActions()
        configureUI()
    }
    
    // MARK: - Selectors

    func handleSignUp() {
        print("회원가입")
    }
    
    func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func configureActions() {
        signUpButton.addAction(
            UIAction { [self] _ in
                handleSignUp()
            },
            for: .touchUpInside
        )
        
        alreadyHaveAccountButton.addAction(
            UIAction { [self] _ in
                handleShowLogin()
            },
            for: .touchUpInside)
    }
    
    func configureUI() {
        view.backgroundColor = .primaryOrange

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
