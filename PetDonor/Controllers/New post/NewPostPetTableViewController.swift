//
//  NewPostPetTableViewController.swift
//  PetDonor
//
//  Created by 18261451 on 15.12.2021.
//

import UIKit

class NewPostPetTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorStyle = .none
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NewPostPetCell", for: indexPath)
    var configuration = cell.defaultContentConfiguration()
    let petImage = [UIImage (named: "CatIcon"), UIImage (named: "DogIcon")]
    let petType = ["Кошка","Собака"]
    configuration.image = petImage [indexPath.row]
    configuration.text = petType [indexPath.row]
    cell.contentConfiguration = configuration
    return cell
  }
}
