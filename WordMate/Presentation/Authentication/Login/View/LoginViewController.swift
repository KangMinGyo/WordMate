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
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.snp.makeConstraints { $0.height.equalTo(50) }
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
        print("로그인")
    }
    
    @objc func handleShowSignUp() {
//        let controller = RegistrationController()
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    }
    
    func setupView() {
        view.backgroundColor = .primaryOrange
        
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
