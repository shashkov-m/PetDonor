//
//  BoardImageTableViewCell.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.02.2022.
//

import UIKit

class BoardImageTableViewCell: UITableViewCell {
  static let identifier = "BoardImageTableViewCell"
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var dateCreateLabel: UILabel!
  @IBOutlet weak var petTypeLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  private func configure () {
    petImageView.contentMode = .scaleAspectFill
    let font = "HelveticaNeue-Light"
    summaryLabel.font = UIFont(name: font, size: 24)
    summaryLabel.numberOfLines = 2
    cityLabel.numberOfLines = 2
    stackView.arrangedSubviews.forEach { view in
      guard let label = view as? UILabel else { return }
      label.font = UIFont(name: font, size: 14)
      label.alpha = 0.7
      label.tintColor = .gray
    }
  }
}
