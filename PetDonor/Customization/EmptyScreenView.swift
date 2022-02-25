//
//  EmptyScreenView.swift
//  PetDonor
//
//  Created by Max Shashkov on 25.02.2022.
//

import UIKit
import SDWebImage
final class EmptyScreenView: UIView {
  let imageView = SDAnimatedImageView ()
  let messageLabel = UILabel ()
  
  func configure () {
    let url = URL (string: "https://firebasestorage.googleapis.com/v0/b/petdonor-46ca2.appspot.com/o/gifs%2FemptyScreenImage.gif?alt=media&token=85575e9a-19b0-46b3-8da8-72f8bde1e345")
    imageView.sd_setImage(with: url, completed: nil)
    messageLabel.text = "Публикаций не найдено"
    self.backgroundColor = .white
    imageView.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(imageView)
    self.addSubview(messageLabel)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint (equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 300),
      imageView.widthAnchor.constraint(equalToConstant: 300),
      imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
      messageLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
      messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
      messageLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -20)
    ])
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    print ("emptyscreen init has been called")
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
