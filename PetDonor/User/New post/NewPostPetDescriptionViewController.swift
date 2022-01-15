//
//  NewPostPetDescriptionViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 20.12.2021.
//
import UIKit
class NewPostPetDescriptionViewController: UIViewController {
  @IBOutlet weak var petDescriptionTextView: UITextView!
  @IBOutlet weak var petContactsTextView: UITextView!
  @IBOutlet weak var petSegmentedControll: UISegmentedControl!
  @IBOutlet weak var petBloodTypeMenu: UIButton!
  @IBOutlet weak var ageTextField: UITextField!
  @IBOutlet weak var rewardTextField: UITextField!
  @IBOutlet weak var rewardSegmentedControl: UISegmentedControl!
  
  var pet:Pet?
  let db = Database.share
  
  override func viewDidLoad() {
    super.viewDidLoad()
    rewardSegmentedControl.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: .valueChanged)
    rewardTextField.delegate = self
    ageTextField.delegate = self
    let tap = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
    toolBarConfiguration ()
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
    pet.reward = {
      if let currentSum = rewardTextField.text, currentSum.count > 0, Int (currentSum) != nil {
        return currentSum
      } else if rewardSegmentedControl.selectedSegmentIndex > 0 {
        let index = rewardSegmentedControl.selectedSegmentIndex
        let string = rewardSegmentedControl.titleForSegment(at: index)
        return string
      } else {
        return "Не указано"
      }
    } ()
    pet.age = {
      if let text = ageTextField.text {
        let formatter = DateFormatter ()
        formatter.dateFormat = "dd.MM.yyyy"
        guard let birthDate = formatter.date(from: text), birthDate <= Date.now else { return "Не указано"}
        return text
        //let calendar = Calendar.current
        //let components = calendar.dateComponents([.year, .month], from: birthDate, to: Date ())
        
      } else {
        return "Не указано"
      }
    } ()
    db.addPet(pet: pet) { result in
      switch result {
      case .failure(let error):
        let alert = UIAlertController (title: "", message: error.localizedDescription, preferredStyle: .alert)
        let retryAction = UIAlertAction (title: "Повторить", style: .default) { _ in
          print ("retry printed")
          self.sendDataButton(self)
        }
        let exitAction = UIAlertAction (title: "Отменить", style: .cancel, handler: nil)
        alert.addAction(exitAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
      case .success(_):
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
  @objc private func segmentedControlDidChange (_ segmentedControl:UISegmentedControl) {
    guard segmentedControl.isEnabledForSegment(at: 0) || segmentedControl.isEnabledForSegment(at: 1) else { return }
    rewardTextField.text?.removeAll()
    view.endEditing(true)
  }
}

extension NewPostPetDescriptionViewController:UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    if textField == rewardTextField {
      guard let text = textField.text, text.count < 6, Int(text) != nil else {
        textField.deleteBackward()
        return
      }
    } else if textField == ageTextField {
      guard let text = textField.text, text.count < 11 else {
        textField.deleteBackward()
        return
      }
    }
  }
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == rewardTextField {
      guard rewardSegmentedControl.isEnabledForSegment(at: 0) || rewardSegmentedControl.isEnabledForSegment(at: 1) else { return }
      rewardSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
    } else if textField == ageTextField {
      guard ageTextField.textColor == .red else { return }
      ageTextField.textColor = .label
    }
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == ageTextField {
      if let text = textField.text, string != "", text.count == 2 || text.count == 5 {
        textField.text?.append(".")
      }
    }
    return true
  }
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    if textField == ageTextField, let string = textField.text, string.count > 0 {
      let formatter = DateFormatter ()
      formatter.dateFormat = "dd.MM.yyyy"
      guard let date = formatter.date(from: string), date <= Date.now else {
        ageTextField.textColor = .red
        shakeAnimation(view: ageTextField)
        return
      }
    }
  }
}
