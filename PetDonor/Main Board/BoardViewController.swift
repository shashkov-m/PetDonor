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
  private var pets = [Pet] ()
  private var isFirtsQuery = false
  private var lastSnapshot:QueryDocumentSnapshot?
  private var isQueryRunning = false
  private let toPetCardSegueIdentifier = "toPetCard"
  private var pet:Pet?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib (nibName: BoardTextOnlyTableViewCell.identifier, bundle: nil),
                       forCellReuseIdentifier: BoardTextOnlyTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
    refreshControlConfigure ()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print ("isFirtsQuery was called value equal ",isFirtsQuery)
    Task {
      do {
        guard isFirtsQuery != true else { return }
        isFirtsQuery = true
        let snapshot = try await db.getPetList()
        let petsArray = db.convertSnapshotToPet(snapshot: snapshot)
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
extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
  
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
    if indexPath.row == pets.count - 2 {
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
