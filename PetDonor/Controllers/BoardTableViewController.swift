//
//  BoardTableViewController.swift
//  PetDonor
//
//  Created by Shashkov Max on 29.11.2021.
//

import UIKit

class BoardTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Доска"
    tableView.register(UINib (nibName: BoardWithImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BoardWithImageTableViewCell.identifier)
    tableView.register(UINib (nibName: BoardTextOnlyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BoardTextOnlyTableViewCell.identifier)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 15
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let imageCell = tableView.dequeueReusableCell(withIdentifier: BoardWithImageTableViewCell.identifier, for: indexPath)
    let textCell = tableView.dequeueReusableCell(withIdentifier: BoardTextOnlyTableViewCell.identifier, for: indexPath)
    switch indexPath.row {
    case 0,2,4,6,7:
      return imageCell
    default:
      return textCell
    }
  }
  
}

extension BoardTableViewController {
  enum AnimalType:String {
    case cat = "Кошка"
    case dog = "Собака"
  }
  
  enum DogBloodType {
    case none
  }
  
  enum CatBloodType {
    case A
    case B
    case AB
    case none
  }
  
}
