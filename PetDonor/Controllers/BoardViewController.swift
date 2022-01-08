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
    Task {
      do {
        guard isFirtsQuery != true else { return }
        isFirtsQuery = true
        let snapshot = try await db.getPetList()
        for document in snapshot.documents {
          let doc = document.data()
          if let petType = doc[PetKeys.petType.rawValue] as? String, let bloodType = doc[PetKeys.bloodType.rawValue] as? String,
             let postType = doc[PetKeys.postType.rawValue] as? String, let description = doc[PetKeys.description.rawValue] as? String,
             let contactInfo = doc[PetKeys.contactInfo.rawValue] as? String, let cityID = doc[PetKeys.cityID.rawValue] as? Int,
             let cityTitle = doc[PetKeys.city.rawValue] as? String, let dateCreate = doc[PetKeys.dateCreate.rawValue] as? Timestamp,
             let isVisible = doc[PetKeys.isVisible.rawValue] as? Bool, let userID = doc[PetKeys.userID.rawValue] as? String
          {
            let city = City (id: cityID, title: cityTitle)
            let date = dateCreate.dateValue()
            let pet = Pet (city: city, description: description, contactInfo: contactInfo, bloodType: bloodType, postType: postType, petType: PetType.init(rawValue: petType), isVisible: isVisible, userID: userID, dateCreate: date)
            pets.append(pet)
            tableView.reloadData()
          } else {
            print ("nah dude")
          }
        }
        lastSnapshot = snapshot.documents.last
      } catch {
        print ("err\(error.localizedDescription)")
      }
    }
  }
  private func refreshControlConfigure () {
    let refreshControl = UIRefreshControl ()
    refreshControl.addTarget(self, action: #selector(refreshPetList), for: .valueChanged)
    tableView.refreshControl = refreshControl
    
  }
  @objc private func refreshPetList () {
    print ("method was called")
    guard let refreshControl = tableView.refreshControl else { return }
    print (refreshControl)
    refreshControl.endRefreshing()
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
    tableView.deselectRow(at: indexPath, animated: true)
    print (pets)
  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == pets.count - 2 {
      guard let fromLastSnapshot = lastSnapshot, isQueryRunning != true else { return }
      isQueryRunning = true
      print ("you should start update here")
      Task {
        do {
          let snapshot = try await db.getNextPetsPart(from: fromLastSnapshot)
          for document in snapshot.documents {
            let doc = document.data()
            if let petType = doc[PetKeys.petType.rawValue] as? String, let bloodType = doc[PetKeys.bloodType.rawValue] as? String,
               let postType = doc[PetKeys.postType.rawValue] as? String, let description = doc[PetKeys.description.rawValue] as? String,
               let contactInfo = doc[PetKeys.contactInfo.rawValue] as? String, let cityID = doc[PetKeys.cityID.rawValue] as? Int,
               let cityTitle = doc[PetKeys.city.rawValue] as? String, let dateCreate = doc[PetKeys.dateCreate.rawValue] as? Timestamp,
               let isVisible = doc[PetKeys.isVisible.rawValue] as? Bool, let userID = doc[PetKeys.userID.rawValue] as? String
            {
              let city = City (id: cityID, title: cityTitle)
              let date = dateCreate.dateValue()
              let pet = Pet (city: city, description: description, contactInfo: contactInfo, bloodType: bloodType, postType: postType, petType: PetType.init(rawValue: petType), isVisible: isVisible, userID: userID, dateCreate: date)
              pets.append(pet)
              tableView.reloadData()
            }
          }
          lastSnapshot = snapshot.documents.last
          isQueryRunning = false
        } catch {
          print (error.localizedDescription)
        }
      }
    }
  }
}
