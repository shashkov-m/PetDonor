//
//  MainBoardHeaderView.swift
//  PetDonor
//
//  Created by Max Shashkov on 27.01.2022.
//

import UIKit

class MainBoardHeaderView: UITableViewHeaderFooterView {
  let dateLabel = UILabel ()
  let postTypeLabel = UILabel ()
  static let identifier = "MainBoardHeaderView"
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func configure () {
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    postTypeLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(dateLabel)
    contentView.addSubview(postTypeLabel)
    dateLabel.textColor = .gray
    NSLayoutConstraint.activate([
      postTypeLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant:  10),
      postTypeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -10),
      dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}
