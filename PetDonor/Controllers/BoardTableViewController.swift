//
//  ViewController.swift
//  PetDonor
//
//  Created by Shashkov Max on 29.11.2021.
//

import UIKit

class BoardTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Board"
    tableView.register(UINib (nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: BoardTableViewCell.identifier)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 15
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.identifier, for: indexPath)
    //cell.textLabel?.text = "privetb"
    return cell
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
