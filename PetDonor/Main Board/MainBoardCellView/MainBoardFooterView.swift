//
//  MainBoardFooterView.swift
//  PetDonor
//
//  Created by Max Shashkov on 27.01.2022.
//

import UIKit

class MainBoardFooterView: UITableViewHeaderFooterView {
  let petTypeLabel = UILabel ()
  let rewardLabel = UILabel ()
  let cityLabel = UILabel ()
  static let identifier = "MainBoardFooterView"
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configure ()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func configure () {
    let stack = UIStackView (arrangedSubviews: [petTypeLabel, cityLabel, rewardLabel])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.alignment = .fill
    stack.distribution = .fill
    stack.axis = .horizontal
    stack.spacing = 8
    let labelFont = UIFont.systemFont(ofSize: 14.0)
    stack.arrangedSubviews.forEach { view in
      guard let label = view as? UILabel else { return }
      label.font = labelFont
    }
    contentView.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 6),
      stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      stack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -6)
    ])
  }
}
