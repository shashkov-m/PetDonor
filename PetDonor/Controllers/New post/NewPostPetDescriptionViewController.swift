//
//  NewPostPetDescriptionViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 20.12.2021.
//

import UIKit

class NewPostPetDescriptionViewController: UIViewController {
  var pet:Pet?
    override func viewDidLoad() {
        super.viewDidLoad()
      print (pet)
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print (pet)
  }
}
