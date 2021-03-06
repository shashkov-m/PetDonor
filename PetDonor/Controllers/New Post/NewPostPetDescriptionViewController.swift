//
//  NewPostPetDescriptionViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 20.12.2021.
//
import UIKit
import PhotosUI
import CropViewController

class NewPostPetDescriptionViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var petDescriptionTextView: UITextView!
  @IBOutlet weak var petContactsTextView: UITextView!
  @IBOutlet weak var petSegmentedControll: UISegmentedControl!
  @IBOutlet weak var petBloodTypeMenu: UIButton!
  @IBOutlet weak var ageTextField: UITextField!
  @IBOutlet weak var rewardTextField: UITextField!
  @IBOutlet weak var rewardSegmentedControl: UISegmentedControl!
  @IBOutlet weak var petImageView: UIImageView!
  private var petImage: UIImage? {
    didSet {
      petImageView.image = petImage
    }
  }
  var pet: Pet?
  let database = Database()
  var isEditingMode = false
  override func viewDidLoad() {
    super.viewDidLoad()
    rewardTextField.delegate = self
    ageTextField.delegate = self
    toolBarConfiguration()
    bloodTypeMenuConfigure()
    rewardSegmentedControl.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: .valueChanged)
    let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
    scrollView.keyboardDismissMode = .interactive
    petImageConfigure(petType: pet?.petType)
    if isEditingMode == true {
      petEditModeConfigure()
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let cornerRadius: CGFloat = 10.0
    petDescriptionTextView.layer.cornerRadius = cornerRadius
    petContactsTextView.layer.cornerRadius = cornerRadius
  }
  @IBAction private func sendDataButton(_ sender: Any) {
    guard var pet = pet else { return }
    let donorType = petSegmentedControll.titleForSegment(at: petSegmentedControll.selectedSegmentIndex)
    let petDescription = petDescriptionTextView.text
    let contactsInfo = petContactsTextView.text
    let bloodType = petBloodTypeMenu.menu?.selectedElements.first?.title
    let now = Date()
    pet.postType = donorType
    pet.description = petDescription
    pet.contactInfo = contactsInfo
    pet.bloodType = bloodType
    pet.dateCreate = now
    if pet.date == nil {
      pet.date = now
    }
    pet.reward = {
      if let currentSum = rewardTextField.text, currentSum.count > 0, Int(currentSum) != nil {
        return currentSum
      } else if rewardSegmentedControl.selectedSegmentIndex >= 0 {
        let index = rewardSegmentedControl.selectedSegmentIndex
        let string = rewardSegmentedControl.titleForSegment(at: index)
        return string
      } else {
        return "???? ??????????????"
      }
    }()
    pet.birthDate = {
      let unixThirtyYears: Double = 946707780
      let thirtyYearsBeforeToday = now.timeIntervalSince1970 - unixThirtyYears
      if let text = ageTextField.text,
         let birthDate = petDateFormatter.date(from: text),
         birthDate <= Date.now,
         birthDate.timeIntervalSince1970 > thirtyYearsBeforeToday {
        return text
      } else {
        return "???? ????????????"
      }
    }()
    database.addPet(pet: pet, image: petImage) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .failure(let error):
        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "??????????????????", style: .default) { _ in
          self.sendDataButton(self)
        }
        let exitAction = UIAlertAction(title: "????????????????", style: .cancel, handler: nil)
        alert.addAction(exitAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
      case .success:
        if self.isEditingMode == true {
          self.navigationController?.popToRootViewController(animated: true)
        } else {
          self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
      }
    }
  }
  @objc private func hideKeyboard() {
    view.endEditing(true)
  }
  private func toolBarConfiguration() {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(hideKeyboard))
    toolbar.items = [flexibleSpace, done]
    toolbar.sizeToFit()
    petDescriptionTextView.inputAccessoryView = toolbar
    petContactsTextView.inputAccessoryView = toolbar
  }
  private func bloodTypeMenuConfigure(editMode: Bool = false) {
    var actions = [UIAction]()
    let bloodTypes = pet?.petType == .cat ? catBloodTypes : dogBloodTypes
    for index in bloodTypes {
      let action = UIAction(title: index, handler: { (_) in })
      if editMode == true, action.title == pet?.bloodType {
        action.state = .on
      }
      actions.append(action)
      let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
      petBloodTypeMenu.showsMenuAsPrimaryAction = true
      petBloodTypeMenu.changesSelectionAsPrimaryAction = true
      petBloodTypeMenu.menu = menu
    }
  }
  private func petEditModeConfigure () {
    guard let pet = pet else { return }
    if let ref = pet.imageUrl {
      let reference = database.getImageReference(from: ref)
      petImageView.sd_setImage(with: reference)
    }
    ageTextField.text = pet.birthDate
    petDescriptionTextView.text = pet.description
    petContactsTextView.text = pet.contactInfo
    bloodTypeMenuConfigure(editMode: true)
    if petSegmentedControll.titleForSegment(at: 1) == pet.postType {
      petSegmentedControll.selectedSegmentIndex = 1
    } else {
      petSegmentedControll.selectedSegmentIndex = 0
    }
    if rewardSegmentedControl.titleForSegment(at: 0) == pet.reward {
      rewardSegmentedControl.selectedSegmentIndex = 0
    } else if rewardSegmentedControl.titleForSegment(at: 1) == pet.reward {
      rewardSegmentedControl.selectedSegmentIndex = 1
    } else {
      rewardTextField.text = pet.reward
    }
  }
  private func petImageConfigure(petType: PetType?) {
    petImageView.contentMode = .scaleAspectFit
    switch petType {
    case .dog:
      let image = UIImage(named: "dogPlaceholder")
      petImageView.image = image
    case .cat:
      let image = UIImage(named: "catPlaceholder")
      petImageView.image = image
    default:
      let image = UIImage(named: "catPlaceholder")
      petImageView.image = image
    }
  }
  @objc private func segmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
    guard segmentedControl.isEnabledForSegment(at: 0) || segmentedControl.isEnabledForSegment(at: 1) else { return }
    rewardTextField.text?.removeAll()
    view.endEditing(true)
  }
  // MARK: PHPhotoPicker
  @IBAction func uploadImageButtonAction(_ sender: Any) {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    present(picker, animated: true)
  }
}

extension NewPostPetDescriptionViewController: PHPickerViewControllerDelegate, CropViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true)
    if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
        DispatchQueue.main.async {
          guard let self = self else { return }
          if let error = error {
            let alert = UIAlertController(title: "????????????", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
          } else {
            guard let image = image as? UIImage else { return }
            self.presentCropViewController(image: image)
          }
        }
      }
    }
  }
  private func presentCropViewController(image: UIImage) {
    let cropViewController = CropViewController(image: image)
    cropViewController.delegate = self
    cropViewController.aspectRatioPickerButtonHidden = true
    present(cropViewController, animated: true, completion: nil)
  }
  func cropViewController(_ cropViewController: CropViewController,
                          didCropToImage image: UIImage,
                          withRect cropRect: CGRect,
                          angle: Int) {
    dismiss(animated: true, completion: nil)
    petImage = image
  }
  func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: UITextFieldDelegate
extension NewPostPetDescriptionViewController: UITextFieldDelegate {
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
      guard rewardSegmentedControl.isEnabledForSegment(at: 0) ||
              rewardSegmentedControl.isEnabledForSegment(at: 1) else { return }
      rewardSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
    } else if textField == ageTextField {
      guard ageTextField.textColor == .red else { return }
      ageTextField.textColor = .label
    }
  }
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    if textField == ageTextField {
      if let text = textField.text, string != "", text.count == 2 || text.count == 5 {
        textField.text?.append(".")
      }
    }
    return true
  }
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if textField == self.ageTextField, let string = textField.text, string.count > 0 {
        let now = Date.now
        let unixThirtyYears: Double = 946707780
        let thirtyYearsBeforeToday = now.timeIntervalSince1970 - unixThirtyYears
        guard let date = petDateFormatter.date(from: string),
              date <= now, date.timeIntervalSince1970 > thirtyYearsBeforeToday
        else {
          self.ageTextField.textColor = .red
          self.ageTextField.applyShakeAnimation()
          return
        }
      }
    }
  }
}
