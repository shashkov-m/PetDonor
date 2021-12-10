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
      return 5
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCityTableViewCell.reuseIdentifier, for: indexPath)
      return cell
    } else {
      return UITableViewCell ()
    }
  }
  
}
