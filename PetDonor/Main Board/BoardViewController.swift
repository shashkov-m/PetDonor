//
//  BoardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.12.2021.
//

import UIKit
import Firebase
class BoardViewController: UIViewController {
  private let db = Database.share
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var postTypeSegmentedControl: UISegmentedControl!
  private var recipients = [Pet] ()
  private var donors = [Pet] ()
  private var recipientLastSnapshot:QueryDocumentSnapshot?
  private var donorLastSnapshot:QueryDocumentSnapshot?
  private var isQueryRunning = false
  private let toPetCardSegueIdentifier = "toPetCard"
  private var pet:Pet?
  private let dateFormatter = DateFormatter ()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register (UINib (nibName: BoardTextOnlyTableViewCell.identifier, bundle: nil),
                        forCellReuseIdentifier: BoardTextOnlyTableViewCell.identifier)
    tableView.register (MainBoardHeaderView.self, forHeaderFooterViewReuseIdentifier: MainBoardHeaderView.identifier)
    tableView.register (MainBoardFooterView.self, forHeaderFooterViewReuseIdentifier: MainBoardFooterView.identifier)
    tableView.delegate = self
    tableView.dataSource = self
    postTypeSegmentedControlConfigure ()
    refreshControlConfigure ()
    updateSegmentData(selectedSegment: postTypeSegmentedControl.selectedSegmentIndex)
    dateFormatter.locale = Locale (identifier: "ru_RU")
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
  }
  
  private func updateSegmentData (selectedSegment:Int) {
    guard (0...1).contains(selectedSegment) else { return }
    Task {
      do {
        if selectedSegment == 0, recipients.isEmpty {
          let snapshot = try await db.getRecipientsList()
          let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
          recipients = petsArray
          tableView.reloadData()
          recipientLastSnapshot = snapshot.documents.last
          
        } else if selectedSegment == 1, donors.isEmpty {
          let snapshot = try await db.getDonorsList()
          let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
          donors = petsArray
          tableView.reloadData()
          donorLastSnapshot = snapshot.documents.last
        } else {
          tableView.reloadData()
        }
      }
    }
  }
  
  private func refreshControlConfigure () {
    let refreshControl = UIRefreshControl ()
    refreshControl.addTarget(self, action: #selector(updatePetList), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  private func postTypeSegmentedControlConfigure () {
    let recipientAction = UIAction (title:"Реципиенты") { [weak self] _ in
      guard let self = self else { return }
      print (self.postTypeSegmentedControl.selectedSegmentIndex)
      self.updateSegmentData(selectedSegment: self.postTypeSegmentedControl.selectedSegmentIndex)
    }
    let donorAction = UIAction (title:"Доноры") { [weak self] _ in
      guard let self = self else { return }
      self.updateSegmentData(selectedSegment: self.postTypeSegmentedControl.selectedSegmentIndex)
      print (self.postTypeSegmentedControl.selectedSegmentIndex)
    }
    postTypeSegmentedControl.setAction(recipientAction, forSegmentAt: 0)
    postTypeSegmentedControl.setAction(donorAction, forSegmentAt: 1)
  }
  
  @objc private func updatePetList () {
    guard let refreshControl = tableView.refreshControl, (0...1).contains(postTypeSegmentedControl.selectedSegmentIndex), !isQueryRunning else { return }
    isQueryRunning = true
    Task {
      do {
        if postTypeSegmentedControl.selectedSegmentIndex == 0 {
          let snapshot = try await db.getRecipientsList()
          let petArray = db.convertSnapshotToPet(snapshot: snapshot)
          recipients.removeAll()
          recipients = petArray
          recipientLastSnapshot = snapshot.documents.last
        } else {
          let snapshot = try await db.getDonorsList()
          let petArray = db.convertSnapshotToPet(snapshot: snapshot)
          donors.removeAll()
          donors = petArray
          donorLastSnapshot = snapshot.documents.last
        }
      }
      isQueryRunning = false
      tableView.reloadData()
      refreshControl.endRefreshing()
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == toPetCardSegueIdentifier, let destinationVC = segue.destination as? PetCardViewController, let pet = pet {
      destinationVC.pet = pet
    }
  }
}
//MARK: UITableViewDelegate
extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if postTypeSegmentedControl.selectedSegmentIndex == 0 {
      return recipients.count
    } else {
      return donors.count
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BoardTextOnlyTableViewCell.identifier, for: indexPath) as! BoardTextOnlyTableViewCell
    let pets:[Pet] = postTypeSegmentedControl.selectedSegmentIndex == 0 ? recipients : donors
    let pet = pets [indexPath.row]
    cell.petTypeLabel.text = pet.petType?.rawValue
    cell.bloodTypeLabel.text = pet.bloodType
    cell.summaryLabel.text = pet.description
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainBoardHeaderView.identifier) as! MainBoardHeaderView
    let pets:[Pet] = postTypeSegmentedControl.selectedSegmentIndex == 0 ? recipients : donors
    let pet = pets [section]
    view.postTypeLabel.text = pet.postType
    if let dateCreate = pet.dateCreate {
      let date = dateFormatter.string(from: dateCreate)
      view.dateLabel.text = date
    }
    return view
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainBoardFooterView.identifier) as! MainBoardFooterView
    let pets:[Pet] = postTypeSegmentedControl.selectedSegmentIndex == 0 ? recipients : donors
    let pet = pets [section]
    view.cityLabel.text = pet.city?.title
    view.rewardLabel.text = "₽\(pet.reward ?? "")"
    view.petTypeLabel.text = pet.petType?.rawValue
    return view
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let pets:[Pet] = postTypeSegmentedControl.selectedSegmentIndex == 0 ? recipients : donors
    pet = pets [indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: toPetCardSegueIdentifier, sender: self)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let selectedIndex = postTypeSegmentedControl.selectedSegmentIndex
    guard (0...1).contains(selectedIndex), !isQueryRunning else { return }
    let pets = selectedIndex == 0 ? recipients : donors
    if pets.count > 3, indexPath.row == pets.count - 2 {
      isQueryRunning = true
      Task {
        do {
          if selectedIndex == 0, let snapshot = recipientLastSnapshot {
            let snapshot = try await db.getNextPetsPart(from: snapshot, for: .recipient)
            let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
            for pet in petsArray {
              recipients.append(pet)
            }
            recipientLastSnapshot = snapshot.documents.last
          } else if let snapshot = donorLastSnapshot {
            let snapshot = try await db.getNextPetsPart(from: snapshot, for: .donor)
            let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
            for pet in petsArray {
              donors.append(pet)
            }
            donorLastSnapshot = snapshot.documents.last
          }
          tableView.reloadData()
          isQueryRunning = false
        }
      }
    }
  }
}
