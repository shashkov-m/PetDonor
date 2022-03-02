//
//  EmptyScreenTableViewCell.swift
//  PetDonor
//
//  Created by Max Shashkov on 25.02.2022.
//

import UIKit
import SDWebImage
final class EmptyScreenTableViewCell: UITableViewCell {
  let placeholderImageView = SDAnimatedImageView()
  let messageLabel = UILabel()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  func configure () {
    guard let asset = NSDataAsset(name: "emptyScreenImage") else { return }
    let data = asset.data
    let image = SDAnimatedImage(data: data)
    let stack = UIStackView(arrangedSubviews: [placeholderImageView, messageLabel])
    stack.alignment = .center
    stack.distribution = .fill
    stack.axis = .vertical
    placeholderImageView.image = image
    placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    stack.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.font = .systemFont(ofSize: 20.0)
    messageLabel.text = "Публикаций не найдено"
    contentView.backgroundColor = .clear
    contentView.addSubview(stack)
    self.selectionStyle = .none
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      placeholderImageView.heightAnchor.constraint(equalToConstant: 300)
    ])
  }
}
