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
    let addButton = UIBarButtonItem (barButtonSystemItem: .add, target: nil, action: #selector(didAddButtonTaped))
    self.navigationItem.setRightBarButton(addButton, animated: true)
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? BoardWithImageTableViewCell {
      print ("cell with image")
    } else if let cell = tableView.cellForRow(at: indexPath) as? BoardTextOnlyTableViewCell {
      print ("text only cell")
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  @objc func didAddButtonTaped () {
    
  }
  
}
