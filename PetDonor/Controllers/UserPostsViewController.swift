//
//  UserPostsViewController.swift
//  PetDonor
//
//  Created by Max Shashkov on 20.12.2021.
//

import UIKit

class UserPostsViewController: UIViewController {
  private let newPetSegue = "createNewPetSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func createNewButtonTapped(_ sender: Any) {
    performSegue(withIdentifier: newPetSegue, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let controller = segue.destination as? UINavigationController, let VC = controller.viewControllers.first as? NewPostPetTableViewController else { return }
    let pet = Pet (city: nil, ownerId: 1, postId: 1,
                   description: nil, contactInfo: nil,
                   bloodType: nil, postType: nil, petType: nil)
    print (pet)
    VC.pet = pet
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == newPetSegue {
      return true
    } else {
      return false
    }
  }
  
}
