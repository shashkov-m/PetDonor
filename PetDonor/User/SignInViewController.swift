//
//  SignInViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 21.12.2021.
//

import UIKit

class SignInViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBAction func enterButton(_ sender: Any) {
  }
  override func viewDidLoad() {
        super.viewDidLoad()
    let tap = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
    }
  @objc private func hideKeyboard () {
    view.endEditing(true)
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
