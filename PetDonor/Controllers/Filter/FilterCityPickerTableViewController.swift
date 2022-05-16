//
//  FilterCityPickerTableViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 02.02.2022.
//

import UIKit

class FilterCityPickerTableViewController: UITableViewController {
  weak var delegate: FiltersViewControllerDelegate?
  let request = CityRequestManager()
  var cities = [City]()
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBarConfigure()
    Task {
      do {
        cities = try await request.getCities(query: nil)
        tableView.reloadData()
      }
    }
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCityCell", for: indexPath)
    guard cities.count > 0 else { return cell}
    var configuration = cell.defaultContentConfiguration()
    let city = cities[indexPath.row]
    configuration.text = city.title
    configuration.secondaryText = city.region
    configuration.secondaryTextProperties.color = .systemGray
    cell.contentConfiguration = configuration
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let city = cities[indexPath.row].title {
      delegate?.updateSelectedCity(city: city)
    }
    navigationController?.popViewController(animated: true)
  }
}
extension FilterCityPickerTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    Task {
      cities = try await request.getCities(query: text)
      tableView.reloadData()
    }
  }
  private func searchBarConfigure() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Введите город"
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
}
