//
//  FAQTableViewCell.swift
//  PetDonor
//
//  Created by Max Shashkov on 22.02.2022.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  static let identifier = "FAQTableViewCell"
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
