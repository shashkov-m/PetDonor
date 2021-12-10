//
//  NewDonorViewController.swift
//  PetDonor
//
//  Created by Shashkov Max on 08.12.2021.
//

import UIKit

class NewDonorViewController: UIViewController {
  let donorView = NewDonorView ()
  override func loadView() {
    view = donorView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
