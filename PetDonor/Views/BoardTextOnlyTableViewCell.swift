//
//  BoardTextOnlyTableViewCell.swift
//  PetDonor
//
//  Created by Shashkov Max on 03.12.2021.
//

import UIKit

class BoardTextOnlyTableViewCell: UITableViewCell {
  static let identifier = "BoardTextOnlyTableViewCell"
  @IBOutlet weak var bloodTypeLabel: UILabel!
  @IBOutlet weak var petTypeLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  private func configure () {
    summaryLabel.text = "Тут совсем другой текст чтобы не был похож на тот, который уже есть короче вот сюда еще что-то пишу точка привет, а еще тут больше на строку и шрифт больше тоже"
    summaryLabel.font = UIFont (name: "HelveticaNeue-Light", size: 26)
    summaryLabel.numberOfLines = 4
    
    petTypeLabel.text = "Собака"
    petTypeLabel.font = UIFont (name: "HelveticaNeue-Light", size: 14)
    petTypeLabel.tintColor = .gray
    petTypeLabel.alpha = 0.7
    
    bloodTypeLabel.text = "Группа крови: А"
    bloodTypeLabel.font = UIFont (name: "HelveticaNeue-Light", size: 14)
    bloodTypeLabel.tintColor = .gray
    bloodTypeLabel.alpha = 0.7
  }
}
