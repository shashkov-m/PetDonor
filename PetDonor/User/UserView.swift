//
//  UserView.swift
//  PetDonor
//
//  Created by Max Shashkov on 30.12.2021.
//

import UIKit

class UserView: UIView {
  lazy var tableView:UITableView = {
    let tableView = UITableView ()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  } ()
  
  lazy var createNewButton:UIButton = {
    let createNewButton = UIButton ()
    createNewButton.translatesAutoresizingMaskIntoConstraints = false
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Создать"
    createNewButton.configuration = configuration
    return createNewButton
  } ()
  
  lazy var logOutButton:UIButton = {
    let logOutButton = UIButton ()
    logOutButton.translatesAutoresizingMaskIntoConstraints = false
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Выйти"
    logOutButton.configuration = configuration
    return logOutButton
  } ()
  
  lazy var navigationBar:UINavigationBar = {
    let navigationBar = UINavigationBar ()
    navigationBar.setBackgroundImage(UIImage (), for: .default)
    navigationBar.shadowImage = UIImage ()
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    return navigationBar
  } ()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    viewConfigure()
    constraintsConfigure()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    viewConfigure()
    constraintsConfigure()
  }
  
  private func viewConfigure () {
    addSubview(tableView)
    addSubview(createNewButton)
    addSubview(navigationBar)
    
  }
  
  private func constraintsConfigure () {
    NSLayoutConstraint.activate ([
      navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      navigationBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      //navigationBar.heightAnchor.constraint(equalToConstant: 44),
      tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      createNewButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -30),
      createNewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 30),
      createNewButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
      createNewButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
}
