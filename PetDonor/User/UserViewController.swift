//
//  Auth.swift
//  PetDonor
//
//  Created by Max Shashkov on 21.12.2021.
//

import UIKit
import Firebase
import grpc

class UserViewController:UIViewController {
  var handle: AuthStateDidChangeListenerHandle?
  let authView = UIView ()
  let signInSegueIdentifier = "signInSegue"
  let signUpSegueIdentifier = "signUpSegue"
  let isAuth = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handle = Auth.auth().addStateDidChangeListener {[weak self] (auth, user) in
      guard let self = self else {return}
      if user != nil {
        self.userLoggedInViewConfigure()
      } else {
        self.authUserViewConfigure()
      }
    }
    
  }
  
  private func authUserViewConfigure () {
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
    
    let backgroundImage = UIImageView ()
    print (traitCollection.userInterfaceStyle.rawValue)
    if traitCollection.userInterfaceStyle == .dark {
      backgroundImage.image = UIImage (named: "catBackgroundWhite")
    } else {
      backgroundImage.image = UIImage (named: "catBackgroundBlack")
    }
    backgroundImage.translatesAutoresizingMaskIntoConstraints = false
    authView.addSubview(backgroundImage)
    backgroundImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
    backgroundImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
    backgroundImage.centerYAnchor.constraint(equalTo: authView.centerYAnchor).isActive = true
    backgroundImage.centerXAnchor.constraint(equalTo: authView.centerXAnchor).isActive = true
  }
  
  private func userLoggedInViewConfigure () {
    if authView.isDescendant(of: view) {
      print ("removed from superview")
      authView.removeFromSuperview()
    }
    let userView = UIView ()
    userView.frame = view.bounds
    view.addSubview(userView)
    let action = UIAction () { action in
      let auth = Auth.auth()
      do {
        try auth.signOut()
      } catch let error {
        print (error)
      }
      
    }
    let logOutButton = UIButton (configuration: .filled(), primaryAction: action)
    
  }
  
  @objc private func signInButtonTapped () {
    performSegue(withIdentifier: signInSegueIdentifier, sender: self)
  }
  
  @objc private func signUpButtonTapped () {
    performSegue(withIdentifier: signUpSegueIdentifier, sender: self)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    Auth.auth().removeStateDidChangeListener(handle!)
  }
}
