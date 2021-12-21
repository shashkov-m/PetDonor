//
//  Auth.swift
//  PetDonor
//
//  Created by Max Shashkov on 21.12.2021.
//

import UIKit

class UserViewController:UIViewController {
  
  var isAuthorized:Bool = false
  let signInSegueIdentifier = "signInSegue"
  let signUpSegueIdentifier = "signUpSegue"
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if isAuthorized != true {
      authUserViewConfigure()
    } else {
      userDetailsViewConfigure()
    }
  }
  
  private func authUserViewConfigure () {
    let authView = UIView ()
    authView.backgroundColor = .systemBackground
    view.addSubview(authView)
    authView.frame = view.bounds
    let signInButton = UIButton ()
    let signUpButton = UIButton ()
    signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    var signInButtonConfiguration = UIButton.Configuration.filled ()
    var signUpButtonConfiguration = UIButton.Configuration.filled ()
    signInButtonConfiguration.title = "Войти"
    signUpButtonConfiguration.title = "Регистрация"
    signInButton.configuration = signInButtonConfiguration
    signUpButton.configuration = signUpButtonConfiguration
    let stack = UIStackView (arrangedSubviews: [signInButton, signUpButton])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 20.0
    authView.addSubview(stack)
    stack.bottomAnchor.constraint(equalTo: authView.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
    stack.leadingAnchor.constraint(equalTo: authView.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    stack.trailingAnchor.constraint(equalTo: authView.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
  }
  
  private func userDetailsViewConfigure () {
    fatalError ("TODO")
  }
  
  @objc private func signInButtonTapped () {
    performSegue(withIdentifier: signInSegueIdentifier, sender: self)
  }
  
  @objc private func signUpButtonTapped () {
    performSegue(withIdentifier: signUpSegueIdentifier, sender: self)
  }
}
