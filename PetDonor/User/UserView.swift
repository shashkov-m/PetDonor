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
    
  }
  
  private func constraintsConfigure () {
    NSLayoutConstraint.activate ([
      tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
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
  deinit {
    print ("UserView has been deallocated")
  }
}
