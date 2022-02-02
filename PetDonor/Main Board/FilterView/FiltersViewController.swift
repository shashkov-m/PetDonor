//
//  MainBoardFiltersViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.12.2021.
//

import UIKit

class FiltersViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  weak var delegate:MainBoardViewControllerDelegate?
  private let toCityPickerSegueIdentifier = "toCityFilterPicker"
  var bloodTypesArray = [String] ()
  var filter = [String:Any] ()
  let citySection = 0
  let petTypeSection = 1
  let bloodTypeSection = 2
  var selectedCity:String?
  var selectedBloodType:String?
  var selectedPetType:PetType? {
    didSet {
      tableView.reloadSections(IndexSet (integer: bloodTypeSection), with: .right)
    }
  }
  let catBloodTypes = ["A","B","AB"]
  let dogBloodTypes = ["DEA 1.1","DEA 1.2","DEA 3","DEA 4","DEA 5","DEA 6","DEA 7"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsMultipleSelection = true
  }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case citySection:
      return 1
    case petTypeSection:
      return PetType.allCases.count
    case bloodTypeSection:
      if selectedPetType == .cat {
        return catBloodTypes.count
      } else if selectedPetType == .dog {
        return dogBloodTypes.count
      } else {
        return 1
      }
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
      return cell
    } else if section == bloodTypeSection {
      let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
      var configuration = cell.defaultContentConfiguration()
      if selectedPetType == .cat {
        cell.accessoryType = .none
        bloodTypesArray = catBloodTypes
      } else if selectedPetType == .dog {
        bloodTypesArray = dogBloodTypes
        cell.accessoryType = .none
      } else {
        bloodTypesArray = ["Сначала уточните вид животного"]
        configuration.textProperties.color = .gray
        cell.accessoryType = .none
      }
      configuration.text = bloodTypesArray [indexPath.row]
      cell.contentConfiguration = configuration
      return cell
    } else {
      fatalError ("TODO")
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
    case petTypeSection:
      let firstIndex = IndexPath (row: 0, section: section)
      let secondIndex = IndexPath (row: 1, section: section)
      let firstCell = tableView.cellForRow(at: firstIndex)
      let secondCell = tableView.cellForRow(at: secondIndex)
      if indexPath == firstIndex, secondCell?.isSelected != nil {
        tableView.deselectRow(at: secondIndex, animated: true)
        secondCell?.accessoryType = .none
      } else if indexPath == secondIndex, firstCell?.isSelected != nil {
        tableView.deselectRow(at: firstIndex, animated: true)
        firstCell?.accessoryType = .none
      }
      selectedPetType = PetType.allCases [row]
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
      break
    case bloodTypeSection:
      guard bloodTypesArray.count > 1 else { break }
      for i in 0...bloodTypesArray.count {
        guard let cell = tableView.cellForRow(at: IndexPath (row: i, section: section)) else { break }
        cell.accessoryType = .none
      }
      if let cell = tableView.cellForRow(at: indexPath) {
        cell.accessoryType = .checkmark
      }
      selectedBloodType = bloodTypesArray [row]
    default:
      break
    }
    delegate?.updateFilter(filter: filter)
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let section = indexPath.section
    switch section {
    case citySection:
      break
    case petTypeSection:
      if selectedPetType == PetType.allCases [indexPath.row] {
        selectedPetType = nil
      }
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
      break
    case bloodTypeSection:
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    default:
      break
    }
    delegate?.updateFilter(filter: filter)
  }
}
