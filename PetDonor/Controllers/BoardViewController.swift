//
//  BoardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.12.2021.
//

import UIKit
import Firebase
class BoardViewController: UIViewController {
  let db = Database.share
  @IBOutlet weak var tableView: UITableView!
  var pets = [Pet] ()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib (nibName: BoardTextOnlyTableViewCell.identifier, bundle: nil),
                       forCellReuseIdentifier: BoardTextOnlyTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Task {
      print ("start task")
      do {
        let snapshot = try await db.getPetList()
        for document in snapshot.documents {
          print ("start cycle")
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
            print (pets)
          } else {
            print ("nah dude")
          }
        }
      } catch {
        print ("err\(error.localizedDescription)")
      }
    }
  }
}

extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BoardTextOnlyTableViewCell.identifier, for: indexPath)
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    print (pets)
  }
}
