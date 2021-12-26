//
//  PasswordRestoreViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 21.12.2021.
//

import UIKit
import Firebase

class PasswordRestoreViewController: UIViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBAction func restorePasswordButton(_ sender: Any) {
    guard let email = emailTextField.text else { return }
    Auth.auth().sendPasswordReset(withEmail: email) {error in
      let alert = UIAlertController (title: nil, message: nil, preferredStyle: .alert)
      if let error = error {
        alert.title = "Ошибка"
        alert.message = error.localizedDescription
        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: nil))
      } else {
        alert.title = ""
        alert.message = "Инструкции по восстановлению пароля отправлены на \(email)"
        alert.addAction(UIAlertAction (title: "OK", style: .default) { (_) in
          self.dismiss(animated: true, completion: nil)
        })
      }
      self.present (alert, animated: true, completion: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
    emailTextField.delegate = self
  }
  @objc private func hideKeyboard () {
    view.endEditing(true)
  }
}

extension PasswordRestoreViewController:UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    restorePasswordButton(self)
    return true
  }
}
