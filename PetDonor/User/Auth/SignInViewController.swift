//
//  SignInViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 21.12.2021.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBAction func enterButton(_ sender: Any) {
    guard let email = emailTextField.text, let password = passwordTextField.text else { return }
    Auth.auth().signIn(withEmail: email, password: password) {result, error in
      if let error = error {
        let alert = UIAlertController (title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present (alert,animated: true)
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
extension SignInViewController:UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      textField.resignFirstResponder()
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      textField.resignFirstResponder()
      enterButton(self)
    }
    return true
  }
}
