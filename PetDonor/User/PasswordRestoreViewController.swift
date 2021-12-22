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
      let alert = UIAlertController ()
      alert.addAction(UIAlertAction (title: "OK", style: .default, handler: nil))
      if let error = error {
        alert.title = "Ошибка"
        alert.message = error.localizedDescription
      } else {
        alert.title = ""
        alert.message = "Инструкции по восстановлению пароля отправлены на \(email)"
      }
      self.present (alert, animated: true, completion: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
  }
  @objc private func hideKeyboard () {
    view.endEditing(true)
  }
}
