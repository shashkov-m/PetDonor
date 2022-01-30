//
//  MainBoardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.12.2021.
//

import UIKit
import Firebase

protocol MainBoardViewControllerDelegate:AnyObject {
  func updateFilter () -> [String:Any]
}

class MainBoardViewController: UIViewController {
  weak var delegate:MainBoardViewControllerDelegate?
  private let db = Database.share
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var postTypeSegmentedControl: UISegmentedControl!
  private var lastSnapshot:QueryDocumentSnapshot?
  private var isQueryRunning = false
  private let toPetCardSegueIdentifier = "toPetCard"
  private let toFiltersListSegueIdentifier = "toFiltersList"
  private var pet:Pet?
  private let dateFormatter = DateFormatter ()
  
  private var pets = [Pet] () {
    didSet {
      print ("Board pets array is up to date")
      print (pets)
      tableView.reloadData()
    }
  }
  
  var filter:[String : Any] = [PetKeys.postType.rawValue : PostType.recipient.rawValue] {
    didSet {
      print ("filter have been updated")
      print (filter)
      reloadPetList (filter: filter)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register (UINib (nibName: BoardTextOnlyTableViewCell.identifier, bundle: nil),
                        forCellReuseIdentifier: BoardTextOnlyTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
    postTypeSegmentedControlConfigure ()
    refreshControlConfigure ()
    dateFormatter.locale = Locale (identifier: "ru_RU")
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    reloadPetList(filter: filter)
  }
  
  private func refreshControlConfigure () {
    let refreshControl = UIRefreshControl ()
    refreshControl.addTarget(self, action: #selector(updatePetList), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  private func postTypeSegmentedControlConfigure () {
    let recipientAction = UIAction (title:"Реципиенты") { [weak self] _ in
      guard let self = self else { return }
      self.filter.updateValue(PostType.recipient.rawValue, forKey: PetKeys.postType.rawValue)
    }
    let donorAction = UIAction (title:"Доноры") { [weak self] _ in
      guard let self = self else { return }
      self.filter.updateValue(PostType.donor.rawValue, forKey: PetKeys.postType.rawValue)
    }
    postTypeSegmentedControl.setAction(recipientAction, forSegmentAt: 0)
    postTypeSegmentedControl.setAction(donorAction, forSegmentAt: 1)
  }
  
  private func reloadPetList (filter: [String : Any]) {
    isQueryRunning = true
    Task {
      do {
        let snapshot = try await db.getPetsWithFilter(filter: filter)
        pets = db.convertSnapshotToPet(snapshot: snapshot)
        lastSnapshot = snapshot.documents.last
      }
    }
    isQueryRunning = false
  }
  
  @objc private func updatePetList () {
    guard let refreshControl = tableView.refreshControl, !isQueryRunning else { return }
    reloadPetList(filter: filter)
    refreshControl.endRefreshing()
  }
  
  @IBAction func filterViewButtonAction(_ sender: Any) {
    performSegue(withIdentifier: toFiltersListSegueIdentifier, sender: self)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == toPetCardSegueIdentifier, let destinationVC = segue.destination as? PetCardViewController, let pet = pet {
      destinationVC.pet = pet
    } else if segue.identifier == toFiltersListSegueIdentifier, let destinationVC = segue.destination as? MainBoardFiltersViewController {
      guard let delegate = delegate else { return }
      destinationVC.filter = filter
      filter = delegate.updateFilter()
    }
  }
}
//MARK: UITableViewDelegate
extension MainBoardViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BoardTextOnlyTableViewCell.identifier, for: indexPath) as! BoardTextOnlyTableViewCell
    let pet = pets [indexPath.row]
    cell.petTypeLabel.text = pet.petType?.rawValue
    cell.bloodTypeLabel.text = pet.bloodType
    cell.summaryLabel.text = pet.description
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    pet = pets [indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: toPetCardSegueIdentifier, sender: self)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let snapshot = lastSnapshot, !isQueryRunning else { return }
    if pets.count > 3, indexPath.row == pets.count - 2 {
      isQueryRunning = true
      Task {
        do {
          let snapshot = try await db.getNextPetsPart(from: snapshot, filterOrNil: filter)
          let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
          for pet in petsArray {
            pets.append(pet)
          }
          lastSnapshot = snapshot.documents.last
        }
        isQueryRunning = false
      }
    }
  }
}
