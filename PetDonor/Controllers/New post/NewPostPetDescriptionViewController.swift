//
//  NewPostPetDescriptionViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 20.12.2021.
//

import UIKit

class NewPostPetDescriptionViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  var pet:Pet?
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
  }
  
  @objc func hideKeyboard () {
    view.endEditing(true)
  }
  
  
  
  
  deinit {
//    NotificationCenter.default.removeObserver(self)
  }
}
