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
  let db = Database ()
  var isFullPermissions = false
  private let toEditPetDataSegue = "toEditPetDataSegue"
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
  
  //MARK: Navigation menu configure
  private func navigationBarConfigure (isFullPermissions:Bool) {
    let shareAction = UIAction (title: "Поделиться", image: UIImage (systemName: "square.and.arrow.up")) {[weak self] _ in
      guard let self = self else { return }
      let text:[Any] = ["""
                        \(self.pet?.petType?.rawValue ?? ""), \(self.pet?.postType ?? ""), \(self.pet?.city?.title ?? "")
                        \(self.pet?.contactInfo ?? "")
                        """]
      let ac = UIActivityViewController (activityItems: text, applicationActivities: nil)
      DispatchQueue.main.async {
        self.present (ac, animated: true, completion: nil )
      }
    }
    var menu = UIMenu (title: "", options: .displayInline, children: [shareAction])
    
    if isFullPermissions == true {
      guard let pet = pet else { return }
      let updateDateCreate = UIAction (title: "Обновить дату публикации", image: UIImage (systemName: "arrow.counterclockwise")) { [weak self] _ in
        guard let self = self else { return }
        var pet = pet
        let now = Date ()
        self.db.updatePetDateCreate (pet: pet)
        pet.dateCreate = now
        self.dateCreateLabel.text = petDateFormatter.string(from: now)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .curveEaseInOut]) {
          self.dateCreateLabel.alpha = 0.1
        } completion: { _ in
          self.dateCreateLabel.alpha = 1
        }
      }
      let changePetData = UIAction (title: "Редактировать", image: UIImage (systemName: "square.and.pencil" )) { [weak self] _ in
        guard let self = self else { return }
        self.performSegue(withIdentifier: self.toEditPetDataSegue, sender: self)
      }
      let deletePet = UIAction (title: "Удалить публикацию", image: UIImage (systemName: "trash")) { [weak self] action in
        guard let self = self else { return }
        let deleteAction = UIAlertAction (title: "Удалить", style: .destructive) { _ in
          self.db.deletePet(pet: pet)
          self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction (title: "Отмена", style: .cancel, handler: nil)
        AlertBuilder.build(presentOn: self, title: "Подтвердите удаление", message: "Публикация будет удалена. Вы сможете создать ее повторно при необходимости", preferredStyle: .alert, actions: [deleteAction, cancelAction])
      }
      //menu = UIMenu (title: "", options: [], children: [shareAction, updateDateCreate, changePetData, deletePet])
      menu = menu.replacingChildren([shareAction, updateDateCreate, changePetData, deletePet])
    }
    
    let moreItem = UIBarButtonItem (title: nil, image: UIImage (systemName: "ellipsis"), primaryAction: nil, menu: menu)
    navigationItem.setRightBarButton(moreItem, animated: true)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let VC = segue.destination as? NewPostPetDescriptionViewController {
      VC.pet = pet
      VC.isEditingMode = true
    }
  }
}
