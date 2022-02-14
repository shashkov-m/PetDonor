//
//  PetCardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 11.01.2022.
//

import UIKit
import FirebaseStorageUI

class PetCardViewController: UIViewController {
  var pet:Pet?
  let db = Database.share
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
      let date = petDateFormatter.string(from: dateCreate)
      dateCreateLabel.text = date
    }
    bloodTypeLabel.text = pet.bloodType
    petTypeLabel.text = pet.petType?.rawValue
    postTypeLabel.text = pet.postType
    cityLabel.text = pet.city?.title
    descriptionLabel.text = pet.description
    contactInfoLabel.text = pet.contactInfo
    rewardLabel.text = pet.reward
    ageLabel.text = pet.age
    if let ref = pet.imageUrl {
      let placeholder = pet.petType == .cat ? UIImage (named: "catPlaceholder") : UIImage (named: "dogPlaceholder")
      let reference = db.getImageReference(from: ref)
      petImageView.sd_setImage(with: reference, placeholderImage: placeholder)
    }
  }
  
  @IBAction func shareButton(_ sender: Any) {
    let text:[Any] = [pet?.petType?.rawValue, pet?.postType, pet?.city?.title, pet?.contactInfo]
    let ac = UIActivityViewController (activityItems: text, applicationActivities: nil)
    present (ac, animated: true, completion: nil )
  }
}
