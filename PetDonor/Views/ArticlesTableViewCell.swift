//
//  ArticlesTableViewCell.swift
//  PetDonor
//
//  Created by Shashkov Max on 01.12.2021.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {
  static let identifier = "ArticlesCell"
  static let nibName = "ArticlesTableViewCell"
  @IBOutlet weak var label:UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    label.text = nil
  }
  
}
