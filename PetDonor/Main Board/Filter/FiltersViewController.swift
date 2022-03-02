//
//  MainBoardFiltersViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.12.2021.
//

import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
  func updateSelectedCity (city: String)
}

class FiltersViewController: UIViewController {
  let catBloodTypes = ["A", "B", "AB"]
  let dogBloodTypes = ["DEA 1+", "DEA 1-"]
  var bloodTypesArray = ["Сначала уточните вид животного"]
  let citySection = 0
  let petTypeSection = 1
  let bloodTypeSection = 2
  weak var delegate: MainBoardViewControllerDelegate?
  @IBOutlet weak var tableView: UITableView!
  private let toCityPickerSegueIdentifier = "toCityFilterPicker"
  var filter = [String: Any]() {
    didSet {
      delegate?.updateFilter(filter: filter)
    }
  }
  var selectedCity: String? {
    willSet {
      guard let selectedCity = newValue else {
        filter.removeValue(forKey: PetKeys.city.rawValue)
        return
      }
      filter.updateValue(selectedCity, forKey: PetKeys.city.rawValue)
    }
  }
  var selectedBloodType: String? {
    didSet {
      guard let selectedBloodType = selectedBloodType else {
        filter.removeValue(forKey: PetKeys.bloodType.rawValue)
        return
      }
      filter.updateValue(selectedBloodType, forKey: PetKeys.bloodType.rawValue)
    }
  }
  var selectedPetType: PetType? {
    willSet {
      if newValue == .cat {
        bloodTypesArray = catBloodTypes
      } else if newValue == .dog {
        bloodTypesArray = dogBloodTypes
      } else {
        bloodTypesArray = ["Сначала уточните вид животного"]
      }
      guard let selectedPetType = newValue?.rawValue else {
        filter.removeValue(forKey: PetKeys.petType.rawValue)
        return
      }
      filter.updateValue(selectedPetType, forKey: PetKeys.petType.rawValue)
    }
    didSet {
      tableView.reloadSections(IndexSet(integer: bloodTypeSection), with: .right)
      if oldValue != nil {
        selectedBloodType = nil
      }
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    restoreState(filter: filter)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsMultipleSelection = true
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  private func restoreState(filter: [String: Any]) {
    guard filter.count > 0 else { return }
    let petTypeString = filter [PetKeys.petType.rawValue] as? String
    if let petTypeString = petTypeString, let petType = PetType.init(rawValue: petTypeString) {
      selectedPetType = petType
    }
    if let city = filter [PetKeys.city.rawValue] as? String {
      selectedCity = city
    }
    if let bloodType = filter [PetKeys.bloodType.rawValue] as? String {
      selectedBloodType = bloodType
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let cityVC = segue.destination as? FilterCityPickerTableViewController {
      cityVC.delegate = self
    }
  }
  @IBAction func resetFilter(_ sender: Any) {
    selectedCity = nil
    selectedPetType = nil
    selectedBloodType = nil
    tableView.reloadData()
  }
}
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case citySection:
      return 1
    case petTypeSection:
      return PetType.allCases.count
    case bloodTypeSection:
      return bloodTypesArray.count
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    if section == citySection {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
      var configuration = cell.defaultContentConfiguration()
      configuration.text = selectedCity ?? "Выберите город поиска"
      cell.contentConfiguration = configuration
      return cell
    } else if section == petTypeSection {
      let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
      var configuration = cell.defaultContentConfiguration()
      configuration.text = PetType.allCases[indexPath.row].rawValue
      cell.contentConfiguration = configuration
      cell.accessoryType = .none
      if let selectedPetType = selectedPetType,
         let index = PetType.allCases.firstIndex(of: selectedPetType),
         index == indexPath.row {
        cell.accessoryType = .checkmark
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
      return cell
    } else if section == bloodTypeSection {
      let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
      var configuration = cell.defaultContentConfiguration()
      cell.accessoryType = .none
      configuration.text = bloodTypesArray [indexPath.row]
      cell.contentConfiguration = configuration
      if let selectedBloodType = selectedBloodType,
         let index = bloodTypesArray.firstIndex(of: selectedBloodType),
         index == indexPath.row {
        cell.accessoryType = .checkmark
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
      return cell
    }
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Город или регион"
    case 1:
      return "Вид животного"
    case 2:
      return "Группа крови"
    default:
      return nil
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = indexPath.section
    let row = indexPath.row
    switch section {
    case citySection:
      tableView.deselectRow(at: indexPath, animated: true)
      performSegue(withIdentifier: toCityPickerSegueIdentifier, sender: self)
    case petTypeSection:
      let firstIndex = IndexPath(row: 0, section: section)
      let secondIndex = IndexPath(row: 1, section: section)
      let firstCell = tableView.cellForRow(at: firstIndex)
      let secondCell = tableView.cellForRow(at: secondIndex)
      if indexPath == firstIndex, secondCell?.isSelected != nil {
        tableView.deselectRow(at: secondIndex, animated: true)
        secondCell?.accessoryType = .none
      } else if indexPath == secondIndex, firstCell?.isSelected != nil {
        tableView.deselectRow(at: firstIndex, animated: false)
        firstCell?.accessoryType = .none
      }
      selectedPetType = PetType.allCases [row]
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    case bloodTypeSection:
      guard bloodTypesArray.count > 1 else { break }
      if let cell = tableView.cellForRow(at: indexPath) {
        cell.accessoryType = .checkmark
      }
      for index in 0...bloodTypesArray.count {
        let bloodTypesIndexPath = IndexPath(row: index, section: section)
        guard bloodTypesIndexPath != indexPath,
              let cell = tableView.cellForRow(at: bloodTypesIndexPath),
              cell.accessoryType != .none
        else {
          continue
        }
        cell.accessoryType = .none
        tableView.deselectRow(at: bloodTypesIndexPath, animated: false)
      }
      selectedBloodType = bloodTypesArray [row]
    default:
      break
    }
  }
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let section = indexPath.section
    switch section {
    case citySection:
      break
    case petTypeSection:
      selectedPetType = nil
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    case bloodTypeSection:
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
      selectedBloodType = nil
    default:
      break
    }
  }
}
// MARK: CityDelegate
extension FiltersViewController: FiltersViewControllerDelegate {
  func updateSelectedCity(city: String) {
    selectedCity = city
  }
}
