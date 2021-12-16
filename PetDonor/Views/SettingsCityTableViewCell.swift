//
//  SettingsCityTableViewCell.swift
//  PetDonor
//
//  Created by Max Shashkov on 10.12.2021.
//

import UIKit

class SettingsCityTableViewCell: UITableViewCell {
  static let reuseIdentifier = "SettingsCityCell"
    
  @IBOutlet weak var titleLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()

  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
}
