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
  private let userPetDetailsSegue = "userPetDetailsSegue"
  private let userView = UserView ()
  private var pets = [Pet] ()
  private var pet:Pet?
  private let db = Database ()
  private var user:User?
  private let maxPetsCount = 3
  private var isQueryRunning = false
  
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
                           preferredStyle: .alert,actions: [UIAlertAction (title: "OK", style: .cancel)])
      }
    }
    for view in view.subviews {
      view.removeFromSuperview()
    }
    userView.frame = view.bounds
    tableViewConfigure()
    refreshControlConfigure ()
    view.addSubview(userView)
    userView.createNewButton.addTarget(self, action: #selector(createNewButtonDidTapped), for: .touchUpInside)
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
    self.navigationItem.setRightBarButton(moreItem, animated: true)
  }
  
  private func authViewConfigure () {
    for view in view.subviews {
      view.removeFromSuperview()
    }
    self.navigationItem.rightBarButtonItem = nil
    let authView = AuthView ()
    authView.frame = view.bounds
    view.addSubview(authView)
    authView.signInButton.addTarget(self, action: #selector(signInButtonDidTapped), for: .touchUpInside)
    authView.signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped), for: .touchUpInside)
  }
  
  @objc private func updatePetList () {
    guard let user = user, let refreshControl = userView.tableView.refreshControl,
          !isQueryRunning else { return }
    isQueryRunning = true
    Task {
      do {
        pets = try await db.getUserPets(for: user)
        isQueryRunning = false
      }
      catch {
        AlertBuilder.build(presentOn: self, title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert, actions: [UIAlertAction (title: "OK", style: .cancel, handler: nil)])
      }
      userView.tableView.reloadSections(IndexSet(integer:0), with: .fade)
      refreshControl.endRefreshing()
    }
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
      AlertBuilder.build(presentOn: self, title: "Ошибка", message: "Невозможно создать больше \(maxPetsCount) объявлений", preferredStyle: .alert, actions: [UIAlertAction (title: "OK", style: .cancel)])
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? UINavigationController,
       let VC = controller.viewControllers.first as? NewPostPetTableViewController,
       let user = user {
      let newPet = Pet (isVisible: true, userID: user.uid)
      VC.pet = newPet
    }
    else if let VC = segue.destination as? PetCardViewController, let pet = pet {
      VC.pet = pet
      VC.isFullPermissions = true
    }
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
    userView.tableView.register(UINib (nibName: BoardImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BoardImageTableViewCell.identifier)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pets.count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BoardImageTableViewCell.identifier, for: indexPath) as! BoardImageTableViewCell
    let pet = pets [indexPath.row]
    cell.summaryLabel.text = pet.description
    cell.petTypeLabel.text = pet.petType?.rawValue
    cell.cityLabel.text = pet.city?.title
    if let dateCreate = pet.dateCreate {
      let date = petDateFormatter.string(from: dateCreate)
      cell.dateCreateLabel.text = date
    }
    let placeholder = pet.petType == .cat ? UIImage (named: "catPlaceholder") : UIImage (named: "dogPlaceholder")
    if let ref = pet.imageUrl, ref.count > 0 {
      let reference = db.getImageReference(from: ref)
      cell.petImageView.sd_setImage(with: reference, maxImageSize: 10_000_000, placeholderImage: placeholder, options: [.refreshCached])
    } else {
      cell.petImageView.image = placeholder
    }
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    pet = pets [indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: userPetDetailsSegue, sender: self)
  }
  private func refreshControlConfigure () {
    let refreshControl = UIRefreshControl ()
    refreshControl.addTarget(self, action: #selector(updatePetList), for: .valueChanged)
    userView.tableView.refreshControl = refreshControl
  }
}
