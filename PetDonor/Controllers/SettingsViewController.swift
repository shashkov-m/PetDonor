//
//  SettingsViewController.swift
//  PetDonor
//
//  Created by 18261451 on 10.12.2021.
//

import UIKit

class SettingsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib (nibName: "SettingsCityTableViewCell", bundle: nil), forCellReuseIdentifier: SettingsCityTableViewCell.reuseIdentifier)
  }
}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 3
    case 2:
      return 7
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCityTableViewCell.reuseIdentifier, for: indexPath) as! SettingsCityTableViewCell
    let section = indexPath.section
    if section == 0 {
    cell.titleLabel.text = "Москва"
    } else if section == 1 {
      cell.titleLabel.text = catBloodTypes [indexPath.row]
      cell.accessoryType = .checkmark
    } else if section == 2 {
      cell.titleLabel.text = dogBloodTypes [indexPath.row]
      cell.accessoryType = .checkmark
    }
      return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Город или регион"
    case 1:
      return "Группы крови кошек"
    case 2:
      return "Группы крови собак"
    default:
      return nil
    }
  }
  
}
