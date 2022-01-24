//
//  PostTableViewCell.swift
//  PetDonor
//
//  Created by Max Shashkov on 24.01.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell {
  static let identifier = "PostTableViewCell"
  @IBOutlet weak var petImageView: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var petTypeLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var postTypeLabel: UILabel!
  @IBOutlet weak var rewardLabel: UILabel!
  @IBOutlet weak var bloodTypeLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  override func prepareForReuse() {
    super.prepareForReuse()
    petImageView.image = nil
    cityLabel.text = nil
    petTypeLabel.text = nil
    descriptionLabel.text = nil
    postTypeLabel.text = nil
    rewardLabel.text = nil
    bloodTypeLabel.text = nil
  }
}
