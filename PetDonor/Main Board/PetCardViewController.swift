//
//  PetCardViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 11.01.2022.
//

import UIKit
import FirebaseStorageUI

class PetCardViewController: UIViewController {
  var pet: Pet?
  let database = Database()
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
      let placeholder = pet.petType == .cat ? UIImage(named: "catPlaceholder"): UIImage(named: "dogPlaceholder")
      let reference = database.getImageReference(from: ref)
      petImageView.sd_setImage(with: reference, placeholderImage: placeholder)
    }
  }
  // MARK: Navigation menu configure
  private func navigationBarConfigure(isFullPermissions: Bool) {
    let shareAction = UIAction(title: "Поделиться",
                               image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
      guard let self = self else { return }
      let petType = self.pet?.petType?.rawValue ?? ""
      let postType = self.pet?.postType ?? ""
      let city = self.pet?.city?.title ?? ""
      let contactInfo = self.pet?.contactInfo ?? ""
      let text: [Any] = ["""
                        \(petType), \(postType), \(city)
                        \(contactInfo)
                        """]
      let activityController = UIActivityViewController(activityItems: text, applicationActivities: nil)
      activityController.popoverPresentationController?.sourceView = self.view
      self.present(activityController, animated: true, completion: nil )
    }
    var menu = UIMenu(title: "", options: .displayInline, children: [shareAction])
    if isFullPermissions == true {
      guard let pet = pet else { return }
      let updateDateCreate = UIAction(title: "Обновить дату публикации",
                                      image: UIImage(systemName: "arrow.counterclockwise")) { [weak self] _ in
        guard let self = self else { return }
        var pet = pet
        let now = Date()
        self.database.updatePetDateCreate(pet: pet)
        pet.dateCreate = now
        self.dateCreateLabel.text = petDateFormatter.string(from: now)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .curveEaseInOut]) {
          self.dateCreateLabel.alpha = 0.1
        } completion: { _ in
          self.dateCreateLabel.alpha = 1
        }
      }
      let changePetData = UIAction(title: "Редактировать",
                                   image: UIImage(systemName: "square.and.pencil" )) { [weak self] _ in
        guard let self = self else { return }
        self.performSegue(withIdentifier: self.toEditPetDataSegue, sender: self)
      }
      let deletePet = UIAction(title: "Удалить публикацию",
                               image: UIImage(systemName: "trash")) { [weak self] _ in
        guard let self = self else { return }
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
          self.database.deletePet(pet: pet)
          self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        AlertBuilder.build(presentOn: self,
                           title: "Подтвердите удаление",
                           message: "Публикация будет удалена. Вы сможете создать ее повторно при необходимости",
                           preferredStyle: .alert,
                           actions: [deleteAction, cancelAction])
      }
      menu = menu.replacingChildren([shareAction, updateDateCreate, changePetData, deletePet])
    }
    let moreItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: menu)
    navigationItem.setRightBarButton(moreItem, animated: true)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let refVC = segue.destination as? NewPostPetDescriptionViewController {
      refVC.pet = pet
      refVC.isEditingMode = true
    }
  }
}
