//
//  ArticlesTableViewCell.swift
//  PetDonor
//
//  Created by Shashkov Max on 01.12.2021.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {
  static let identifier = "ArticlesTableViewCell"
  @IBOutlet weak var articleLabel:UILabel!
  @IBOutlet weak var articleImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
