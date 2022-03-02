//
//  CityPickerViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 17.12.2021.
//

import UIKit

class CityPickerViewController: UIViewController {
  var pet: Pet?
  @IBOutlet weak var tableView: UITableView!
  let request = CityRequestManager()
  var cities = [City]()
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    searchBarConfigure()
    Task {
      do {
        cities = try await request.getCities(query: nil)
        tableView.reloadData()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

extension CityPickerViewController: UITableViewDelegate, UITableViewDataSource {
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
    configuration.secondaryText = city.region
    configuration.secondaryTextProperties.color = .systemGray
    cell.contentConfiguration = configuration
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    pet?.city = cities [indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "toPetDescribe", sender: self)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let refVC = segue.destination as? NewPostPetDescriptionViewController else { return }
    refVC.pet = pet
  }
}
extension CityPickerViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    Task {
      cities = try await request.getCities(query: text)
      tableView.reloadData()
    }
  }
  private func searchBarConfigure () {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Введите город"
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
}
