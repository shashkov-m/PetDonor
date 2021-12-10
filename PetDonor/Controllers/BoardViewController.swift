//
//  BoardViewController.swift
//  PetDonor
//
//  Created by 18261451 on 10.12.2021.
//

import UIKit

class BoardViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib (nibName: BoardTextOnlyTableViewCell.identifier, bundle: nil),
                       forCellReuseIdentifier: BoardTextOnlyTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BoardTextOnlyTableViewCell.identifier, for: indexPath)
    return cell
  }
}
