//
//  BoardTableViewCell.swift
//  PetDonor
//
//  Created by Shashkov Max on 01.12.2021.
//

import UIKit

class BoardTableViewCell: UITableViewCell {
  static let identifier = "BoardCell"
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var bloodTypeLabel: UILabel!
  @IBOutlet weak var petTypeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  private func configure () {
    let literal = #imageLiteral(resourceName: "photo_2021-12-02 18.29.33")
    previewImage.image = literal
    previewImage.contentMode = .scaleAspectFill
    previewImage.layer.cornerRadius = 20
    
    summaryLabel.text = "Кисулькен кисулькен привет вот такой вот, а это если максимум три строчки и все потом что будет?"
    summaryLabel.font = UIFont (name: "HelveticaNeue-Light", size: 24)
    summaryLabel.numberOfLines = 3
    
    petTypeLabel.text = "Кошка"
    petTypeLabel.font = UIFont (name: "HelveticaNeue-Light", size: 14)
    petTypeLabel.tintColor = .gray
    petTypeLabel.alpha = 0.7
    
    bloodTypeLabel.text = "Группа крови: B"
    bloodTypeLabel.font = UIFont (name: "HelveticaNeue-Light", size: 14)
    bloodTypeLabel.tintColor = .gray
    bloodTypeLabel.alpha = 0.7
  }
  
}
