//
//  ArticalsTableViewController.swift
//  PetDonor
//
//  Created by Shashkov Max on 30.11.2021.
//

import UIKit

class ArticlesTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    return cell
  }
}
