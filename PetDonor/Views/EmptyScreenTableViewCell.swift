//
//  EmptyScreenTableViewCell.swift
//  PetDonor
//
//  Created by Max Shashkov on 25.02.2022.
//

import UIKit
import SDWebImage
final class EmptyScreenTableViewCell: UITableViewCell {
  let placeholderImageView = SDAnimatedImageView ()
  let messageLabel = UILabel ()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func configure () {
    guard let asset = NSDataAsset (name: "emptyScreenImage") else { return }
    let data = asset.data
    let image = SDAnimatedImage (data: data)
    placeholderImageView.image = image
    placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.font = .systemFont(ofSize: 20.0)
    messageLabel.text = "Публикаций не найдено"
    contentView.backgroundColor = .clear
    contentView.addSubview(placeholderImageView)
    contentView.addSubview(messageLabel)
    self.selectionStyle = .none
    
    NSLayoutConstraint.activate([
      placeholderImageView.topAnchor.constraint (equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
      placeholderImageView.heightAnchor.constraint(equalToConstant: 300),
      placeholderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      placeholderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      messageLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 10),
      messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
      messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 20)
    ])
  }
  
}
