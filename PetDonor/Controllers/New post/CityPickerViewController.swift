//
//  CityPickerViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 17.12.2021.
//

import UIKit

class CityPickerViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  let request = CityRequestManager ()
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    let url = request.urlComponentsDefault.url
    Task {
      do {
        try await request.getCities()
      } catch {
        print (error.localizedDescription)
      }
    }
  }
  
}

extension CityPickerViewController:UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell ()
  }
  
  
}
