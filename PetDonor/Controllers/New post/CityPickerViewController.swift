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
  var cities = [City] ()
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    Task {
      do {
        cities = try await request.getCities()
        tableView.reloadData()
        print (cities)
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
    return cities.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
    guard cities.count > 0 else { return cell}
    var configuration = cell.defaultContentConfiguration()
    let city = cities [indexPath.row]
    configuration.text = city.title
    configuration.secondaryText = city.area
    cell.contentConfiguration = configuration
    return cell
  }
}
