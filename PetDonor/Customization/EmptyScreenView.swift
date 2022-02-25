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
    guard let asset = NSDataAsset (name: "emptyScreenImage") else { return }
    let data = asset.data
    let image = SDAnimatedImage (data: data)
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.font = .systemFont(ofSize: 20.0)
    messageLabel.text = "Публикаций не найдено"
    self.backgroundColor = .clear
    self.addSubview(imageView)
    self.addSubview(messageLabel)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint (equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 300),
      imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
      messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
      messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: 20)
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
