//
//  PetCardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 11.01.2022.
//

import UIKit

class PetCardViewController: UIViewController {
  var pet:Pet?
  let formatter = DateFormatter ()
  @IBOutlet weak var petTypeLabel: UILabel!
  @IBOutlet weak var bloodTypeLabel: UILabel!
  @IBOutlet weak var postTypeLabel: UILabel!
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var contactInfoLabel: UILabel!
  @IBOutlet weak var dateCreateLabel: UILabel!
  @IBOutlet weak var rewardLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewConfigure()
  }
  
  private func viewConfigure () {
    guard let pet = pet else { return }
    if let dateCreate = pet.dateCreate {
      formatter.dateFormat = "dd.MM.yyyy hh:mm"
      let date = formatter.string(from: dateCreate)
      dateCreateLabel.text = date
    }
    bloodTypeLabel.text = pet.bloodType
    petTypeLabel.text = pet.petType?.rawValue
    postTypeLabel.text = pet.postType
    cityLabel.text = pet.city?.title
    descriptionLabel.text = pet.description
    contactInfoLabel.text = pet.contactInfo
    ageLabel.text = pet.age
  }
}
