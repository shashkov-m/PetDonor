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
  var isFullPermissions = false
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
    navigationBarConfigure(isFullPermissions: isFullPermissions)
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
    
  private func navigationBarConfigure (isFullPermissions:Bool) {
    let shareAction = UIAction (title: "Поделиться", image: UIImage (systemName: "square.and.arrow.up")) { _ in
      let text:[Any] = [self.pet?.petType?.rawValue, self.pet?.postType, self.pet?.city?.title, self.pet?.contactInfo]
      let ac = UIActivityViewController (activityItems: text, applicationActivities: nil)
      self.present (ac, animated: true, completion: nil )
    }
    var menu = UIMenu (title: "", options: .displayInline, children: [shareAction])
    if isFullPermissions == true {
      let updateDateCreate = UIAction (title: "Обновить дату публикации", image: UIImage (systemName: "arrow.counterclockwise")) { _ in
        
      }
      let changePetData = UIAction (title: "Редактировать", image: UIImage (systemName: "square.and.pencil" )) { _ in
        
      }
      let deletePet = UIAction (title: "Удалить публикацию", image: UIImage (systemName: "trash")) { action in
        
      }
      menu = menu.replacingChildren([shareAction, updateDateCreate, changePetData, deletePet])
    }
    let moreItem = UIBarButtonItem (title: nil, image: UIImage (systemName: "ellipsis"), primaryAction: nil, menu: menu)
    self.navigationItem.setRightBarButton(moreItem, animated: true)
    print (isFullPermissions)
  }
}
