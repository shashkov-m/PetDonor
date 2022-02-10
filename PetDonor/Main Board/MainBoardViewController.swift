//
//  MainBoardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.12.2021.
//

import UIKit
import Firebase

protocol MainBoardViewControllerDelegate:AnyObject {
  func updateFilter (filter: [String:Any])
}

class MainBoardViewController: UIViewController {
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
      guard tableView.window != nil else { return }
      tableView.reloadSections(IndexSet (integer: 0), with: .fade)
    }
  }
  
  var filter:[String : Any] = [PetKeys.postType.rawValue : PostType.recipient.rawValue] {
    didSet {
      guard view.window != nil else { return }
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print ("Will appear")
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
        print ("88888",lastSnapshot)
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
    } else if segue.identifier == toFiltersListSegueIdentifier, let destinationVC = segue.destination as? FiltersViewController {
      destinationVC.filter = filter
      destinationVC.delegate = self
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
    print ("11111",lastSnapshot,isQueryRunning)
    guard let snapshot = lastSnapshot, !isQueryRunning else { return }
    print ("2222")
    print ("pets count = ",pets.count)
    if pets.count > 4, indexPath.row == pets.count - 2 {
      print ("33333")
      isQueryRunning = true
      Task {
        do {
          let snapshot = try await db.getNextPetsPart(from: snapshot, filterOrNil: filter)
          let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
          print (petsArray)
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

extension MainBoardViewController:MainBoardViewControllerDelegate {
  func updateFilter(filter: [String : Any]) {
    self.filter = filter
  }
  
  
}
