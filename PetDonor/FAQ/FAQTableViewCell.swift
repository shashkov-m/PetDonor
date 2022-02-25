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
  @IBOutlet weak var questionView: UIView!
  @IBOutlet weak var answerView: UIView!
  @IBOutlet weak var accessoryImageView: UIImageView!
  
  
  static let identifier = "FAQTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func hideAnswerView () {
    answerView.isHidden = true
    accessoryImageView.transform = .identity
  }
  
  private func showAnswerView () {
    answerView.isHidden = false
    accessoryImageView.transform = CGAffineTransform (rotationAngle: .pi)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      showAnswerView()
    } else {
      hideAnswerView()
    }
  }
  
}
