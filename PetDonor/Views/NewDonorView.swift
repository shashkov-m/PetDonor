//
//  NewDonorView.swift
//  PetDonor
//
//  Created by Shashkov Max on 08.12.2021.
//

import UIKit

class NewDonorView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    createSubviews ()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func createSubviews () {
    let petImage = UIImage ()
    let pet = Pet ()
    let segmentItems = [Pet.PetType.cat,Pet.PetType.dog]
    let petType = UISegmentedControl (items: segmentItems)
    
    
  }
}
