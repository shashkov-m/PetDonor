//
//  SignUpViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 21.12.2021.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBAction func signUpButton(_ sender: Any) {
    guard let email = emailTextField.text, let password = passwordTextField.text else { return }
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      if let error = error {
        let alert = UIAlertController (title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: nil))
        self.present (alert, animated: true, completion: nil)
      } else if result != nil {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }
  @objc private func hideKeyboard () {
    view.endEditing(true)
  }
}

extension SignUpViewController:UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      textField.resignFirstResponder()
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      textField.resignFirstResponder()
      signUpButton(self)
    }
    return true
  }
}
