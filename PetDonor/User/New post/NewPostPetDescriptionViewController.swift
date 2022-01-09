//
//  NewPostPetDescriptionViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 20.12.2021.
//

import UIKit

class NewPostPetDescriptionViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var petDescriptionTextView: UITextView!
  @IBOutlet weak var petContactsTextView: UITextView!
  @IBOutlet weak var petSegmentedControll: UISegmentedControl!
  @IBOutlet weak var petBloodTypeMenu: UIButton!
  @IBOutlet weak var petIcon: UIImageView!
  var pet:Pet?
  let db = Database.share
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
    toolBarConfiguration ()
    petIconConfigure()
    bloodTypeMenuConfigure()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let cornerRadius:CGFloat = 10.0
    petDescriptionTextView.layer.cornerRadius = cornerRadius
    petContactsTextView.layer.cornerRadius = cornerRadius
  }
  
  @IBAction private func sendDataButton(_ sender: Any) {
    guard var pet = pet else { return }
    let donorType = petSegmentedControll.titleForSegment(at: petSegmentedControll.selectedSegmentIndex)
    let petDescription = petDescriptionTextView.text
    let contactsInfo = petContactsTextView.text
    let bloodType = petBloodTypeMenu.menu?.selectedElements.first?.title
    let now = Date ()
    pet.postType = donorType
    pet.description = petDescription
    pet.contactInfo = contactsInfo
    pet.bloodType = bloodType
    pet.dateCreate = now
    db.addPet(pet: pet) { error in
      if let error = error {
        let alert = UIAlertController (title: "", message: error.localizedDescription, preferredStyle: .alert)
        let retryAction = UIAlertAction (title: "Повторить", style: .default) { _ in
          print ("retry printed")
          self.sendDataButton(self)
        }
        let exitAction = UIAlertAction (title: "Отменить", style: .cancel, handler: nil)
        alert.addAction(exitAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
      } else {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  @objc private func hideKeyboard () {
    view.endEditing(true)
  }
  private func toolBarConfiguration () {
    let toolbar = UIToolbar (frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
    let flexibleSpace = UIBarButtonItem (barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem (title: "Done", style: .done, target: self, action: #selector(hideKeyboard))
    toolbar.items = [flexibleSpace, done]
    toolbar.sizeToFit()
    petDescriptionTextView.inputAccessoryView = toolbar
    petContactsTextView.inputAccessoryView = toolbar
  }
  
  private func bloodTypeMenuConfigure () {
    var actions = [UIAction] ()
    let bloodTypes = pet?.petType == .cat ? catBloodTypes : dogBloodTypes
    for i in bloodTypes {
      let action = UIAction (title: i, handler: { (_) in })
      actions.append(action)
      let menu = UIMenu (title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
      petBloodTypeMenu.showsMenuAsPrimaryAction = true
      petBloodTypeMenu.changesSelectionAsPrimaryAction = true
      petBloodTypeMenu.menu = menu
    }
  }
  
  private func petIconConfigure () {
    guard let pet = pet else { return }
    if pet.petType == .cat {
      petIcon.image = UIImage (named: "catIcon")
    } else {
      petIcon.image = UIImage (named: "dogIcon")
    }
    petIcon.layer.cornerRadius = 25.0
  }
}
