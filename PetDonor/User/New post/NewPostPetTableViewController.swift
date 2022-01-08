//
//  NewPostPetTableViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 15.12.2021.
//

import UIKit

class NewPostPetTableViewController: UITableViewController {
  var pet:Pet?
//  let petType = ["Кошка","Собака"]
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorStyle = .none
  }
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
    let petImage = [UIImage (named: "catIcon"), UIImage (named: "dogIcon")]
    configuration.image = petImage [indexPath.row]
    configuration.text = PetType.allCases [indexPath.row].rawValue
    cell.contentConfiguration = configuration
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    pet?.petType = PetType.allCases [indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "toCityPicker", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let VC = segue.destination as? CityPickerViewController else { return }
    VC.pet = pet
  }
  
}
