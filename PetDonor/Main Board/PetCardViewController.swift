//
//  PetCardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 11.01.2022.
//

import UIKit

class PetCardViewController: UIViewController {
  var pet:Pet?
  @IBOutlet weak var petTypeLabel: UILabel!
  @IBOutlet weak var bloodTypeLabel: UILabel!
  @IBOutlet weak var postTypeLabel: UILabel!
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var petInfoLabel: UILabel!
  @IBOutlet weak var contactInfoLabel: UILabel!
  @IBOutlet weak var dateCreateLabel: UILabel!
  @IBOutlet weak var rewardLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewConfigure()
  }
  
  private func viewConfigure () {
    guard let pet = pet, let dateCreate = pet.dateCreate, let bloodType = pet.bloodType else {
      return
    }
    let formatter = DateFormatter ()
    formatter.dateFormat = "dd.MM.yyyy hh:mm"
    let date = formatter.string(from: dateCreate)
    petTypeLabel.text = pet.petType?.rawValue
    bloodTypeLabel.text = "Группа крови \(bloodType)"
    postTypeLabel.text = pet.postType
    cityLabel.text = pet.city?.title
    petInfoLabel.text = pet.description
    contactInfoLabel.text = pet.contactInfo
    dateCreateLabel.text = "Дата публикации \(date)"
  }
}
