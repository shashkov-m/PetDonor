//
//  UserViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 21.12.2021.
//

import UIKit
import Firebase

class UserViewController:UIViewController {
  private var handle: AuthStateDidChangeListenerHandle?
  private let newPetSegue = "createNewPetSegue"
  private let signInSegueIdentifier = "signInSegue"
  private let signUpSegueIdentifier = "signUpSegue"
  private let userView = UserView ()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
      guard let self = self else {return}
      if user != nil {
        self.userViewConfigure()
      } else {
        self.authViewConfigure()
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    Auth.auth().removeStateDidChangeListener(handle!)
  }
  
  private func userViewConfigure () {
    for view in view.subviews {
      view.removeFromSuperview()
    }
    userView.frame = view.bounds
    tableViewConfigure()
    view.addSubview(userView)
    userView.createNewButton.addTarget(self, action: #selector(createNewButtonDidTapped), for: .touchUpInside)
    let navigationItem = UINavigationItem ()
    let logOutButton = UIAction (title: "Выйти") { _ in
      let auth = Auth.auth()
      do {
        try auth.signOut()
      } catch let error {
        print (error)
      }
    }
    let menu = UIMenu (title: "", options: .displayInline, children: [logOutButton])
    let moreItem = UIBarButtonItem (title: nil, image: UIImage (systemName: "ellipsis"), primaryAction: nil, menu: menu)
    navigationItem.rightBarButtonItem = moreItem
    userView.navigationBar.setItems([navigationItem], animated: false)
  }
  
  private func authViewConfigure () {
    for view in view.subviews {
      view.removeFromSuperview()
    }
    let authView = AuthView ()
    authView.frame = view.bounds
    view.addSubview(authView)
    authView.signInButton.addTarget(self, action: #selector(signInButtonDidTapped), for: .touchUpInside)
    authView.signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped), for: .touchUpInside)
  }
  
  @objc private func signInButtonDidTapped () {
    performSegue(withIdentifier: signInSegueIdentifier, sender: self)
  }
  
  @objc private func signUpButtonDidTapped () {
    performSegue(withIdentifier: signUpSegueIdentifier, sender: self)
  }
  @objc private func createNewButtonDidTapped () {
    performSegue(withIdentifier: newPetSegue, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let controller = segue.destination as? UINavigationController, let VC = controller.viewControllers.first as? NewPostPetTableViewController else { return }
    let pet = Pet (isVisible: true)
    print (pet)
    VC.pet = pet
  }
  
  @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
  }
}


extension UserViewController:UITableViewDataSource, UITableViewDelegate {
  private func tableViewConfigure () {
    userView.tableView.dataSource = self
    userView.tableView.delegate = self
    userView.tableView.separatorStyle = .none
    userView.tableView.register (UITableViewCell.self, forCellReuseIdentifier: "userPetTableViewCell")
  }
  
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
