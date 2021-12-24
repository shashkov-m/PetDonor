//
//  Auth.swift
//  PetDonor
//
//  Created by Max Shashkov on 21.12.2021.
//

import UIKit
import Firebase

class UserViewController:UIViewController {
  let tableView = UITableView ()
  var handle: AuthStateDidChangeListenerHandle?
  let authView = UIView ()
  let signInSegueIdentifier = "signInSegue"
  let signUpSegueIdentifier = "signUpSegue"
  let isAuth = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register (UITableViewCell.self, forCellReuseIdentifier: "userPetTableViewCell")
    tableView.separatorStyle = .none
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
    userView.addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: userView.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: userView.safeAreaLayoutGuide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: userView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: userView.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
    let createNewButton = UIButton ()
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Создать"
    createNewButton.configuration = configuration
    let action = UIAction () { action in
      let auth = Auth.auth()
      do {
        try auth.signOut()
      } catch let error {
        print (error)
      }
    }
    createNewButton.addAction(action, for: .touchUpInside)
    userView.addSubview(createNewButton)
    createNewButton.translatesAutoresizingMaskIntoConstraints = false
    createNewButton.bottomAnchor.constraint(equalTo: userView.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    createNewButton.leadingAnchor.constraint(equalTo: userView.leadingAnchor,constant: 30).isActive = true
    createNewButton.trailingAnchor.constraint(equalTo: userView.trailingAnchor, constant: -30).isActive = true
    createNewButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
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

extension UserViewController:UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "userPetTableViewCell", for: indexPath)
    var configuration = cell.defaultContentConfiguration()
    configuration.image = UIImage (named: "catBackgroundBlack")
    configuration.imageProperties.maximumSize = CGSize (width: 200.0, height: 200.0)
    configuration.text = "some text here"
    configuration.secondaryText = "secondary text here"
    cell.contentConfiguration = configuration
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
