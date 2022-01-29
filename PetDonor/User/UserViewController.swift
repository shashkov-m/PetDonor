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
  private var pets = [Pet] ()
  private let db = Database.share
  private var user:User?
  private let maxPetsCount = 3
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, currentUser) in
      guard let self = self else {return}
      if let currentUser = currentUser {
        self.userViewConfigure(user: currentUser)
        self.user = currentUser
      } else {
        self.authViewConfigure()
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    Auth.auth().removeStateDidChangeListener(handle!)
  }
  
  private func userViewConfigure (user: User) {
    Task {
      do {
        pets = try await db.getUserPets(for: user)
        userView.tableView.reloadData()
      } catch let error {
        AlertBuilder.build(presentOn: self, title: "Ошибка", message: error.localizedDescription,
                           preferredStyle: .alert,action: UIAlertAction (title: "OK", style: .cancel))
      }
    }
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
    if pets.count < maxPetsCount {
      performSegue(withIdentifier: newPetSegue, sender: self)
    } else {
      AlertBuilder.build(presentOn: self, title: "Ошибка", message: "Невозможно создать больше \(maxPetsCount) объявлений", preferredStyle: .alert, action: UIAlertAction (title: "OK", style: .cancel))
    }
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let controller = segue.destination as? UINavigationController,
          let VC = controller.viewControllers.first as? NewPostPetTableViewController,
          let user = user
    else {
      return
    }
    let pet = Pet (isVisible: true, userID: user.uid)
    VC.pet = pet
  }
  
  @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
  }
}

//MARK: UITableViewDelegate
extension UserViewController:UITableViewDataSource, UITableViewDelegate {
  private func tableViewConfigure () {
    userView.tableView.dataSource = self
    userView.tableView.delegate = self
    userView.tableView.separatorStyle = .none
    userView.tableView.register(UINib (nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pets.count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else { fatalError ("TODO") }
    let pet = pets [indexPath.row]
    cell.bloodTypeLabel.text = pet.bloodType
    cell.rewardLabel.text = pet.reward
    cell.postTypeLabel.text = pet.postType
    cell.descriptionLabel.text = pet.description
    cell.petTypeLabel.text = pet.petType?.rawValue
    cell.cityLabel.text = pet.city?.title
    cell.petImageView.image = UIImage (named: "catPlaceholder")
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
