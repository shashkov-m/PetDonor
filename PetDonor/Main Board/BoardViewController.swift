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
  private var pets = [Pet] ()
  private var isFirtsQuery = false
  private var lastSnapshot:QueryDocumentSnapshot?
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
    dateFormatter.locale = Locale (identifier: "ru_RU")
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print ("isFirtsQuery was called value equal ",isFirtsQuery)
    Task {
      do {
        guard isFirtsQuery != true else { return }
        isFirtsQuery = true
        let snapshot = try await db.getPetList()
        print (snapshot.documents.count)
        let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
        print (petsArray)
        for pet in petsArray {
          pets.append(pet)
        }
        tableView.reloadData()
        lastSnapshot = snapshot.documents.last
      } catch {
        print ("err\(error.localizedDescription)")
      }
    }
  }
  private func refreshControlConfigure () {
    let refreshControl = UIRefreshControl ()
    refreshControl.addTarget(self, action: #selector(updatePetList), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  private func postTypeSegmentedControlConfigure () {
    let recipientAction = UIAction (title:"Реципиенты") { action in
      print ("Recipient action has been called")
    }
    let donorAction = UIAction (title:"Доноры") { action in
      print ("Donor action has been called")
    }
    postTypeSegmentedControl.setAction(recipientAction, forSegmentAt: 0)
    postTypeSegmentedControl.setAction(donorAction, forSegmentAt: 1)
  }
  
  @objc private func updatePetList () {
    guard let refreshControl = tableView.refreshControl else { return }
    Task {
      do {
        let snapshot = try await db.getPetList()
        guard snapshot.count > 0
        else {
          refreshControl.endRefreshing()
          return
        }
        let petArray = db.convertSnapshotToPet(snapshot: snapshot)
        lastSnapshot = snapshot.documents.last
        pets.removeAll()
        for pet in petArray {
          pets.append(pet)
        }
      } catch {
        print (error.localizedDescription)
      }
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
    return pets.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BoardTextOnlyTableViewCell.identifier, for: indexPath) as! BoardTextOnlyTableViewCell
    let pet = pets [indexPath.row]
    cell.petTypeLabel.text = pet.petType?.rawValue
    cell.bloodTypeLabel.text = pet.bloodType
    cell.summaryLabel.text = pet.description
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainBoardHeaderView.identifier) as! MainBoardHeaderView
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
    let pet = pets [section]
    view.cityLabel.text = pet.city?.title
    view.rewardLabel.text = "₽\(pet.reward ?? "")"
    view.petTypeLabel.text = pet.petType?.rawValue
    return view
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    pet = pets [indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: toPetCardSegueIdentifier, sender: self)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if pets.count > 3, indexPath.row == pets.count - 2 {
      guard let fromLastSnapshot = lastSnapshot, isQueryRunning != true else {
        print ("ELSE CASE HAPPEN", isQueryRunning)
        return }
      isQueryRunning = true
      print ("you should start update here")
      Task {
        do {
          let snapshot = try await db.getNextPetsPart(from: fromLastSnapshot)
          let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
          for pet in petsArray {
            pets.append(pet)
          }
          tableView.reloadData()
          lastSnapshot = snapshot.documents.last
          isQueryRunning = false
        } catch {
          print (error.localizedDescription)
        }
      }
    }
  }
}
