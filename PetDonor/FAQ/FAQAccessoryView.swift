//
//  FAQAccessoryView.swift
//  PetDonor
//
//  Created by Max Shashkov on 23.02.2022.
//

import UIKit

class FAQAccessoryView: UIView {
  let image = UIImageView ()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func configure () {
    image.image = UIImage (systemName: "chevron.up")
    image.frame = bounds
    image.tintColor = .red
    backgroundColor = .clear
  }
}
