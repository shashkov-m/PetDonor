//
//  NewDonorView.swift
//  PetDonor
//
//  Created by Shashkov Max on 08.12.2021.
//

import UIKit

class NewDonorView: UIView {
  
  let contactInfoLabel = UILabel ()
  let descriptionLabel = UILabel ()
  let bloodTypeLabel = UILabel ()
  let imageView = UIImageView ()
  let petTypeControl = UISegmentedControl ()
  let donorTypeControl = UISegmentedControl ()
  let bloodTypeButton = UIButton ()
  let descriptionText = UITextField ()
  let contactInfoText = UITextField ()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .systemBackground
    configureConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureConstraints () {
    let stack = UIStackView (arrangedSubviews: [donorTypeControl, petTypeControl])
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 20
    
    descriptionLabel.text = "Описание"
    
    donorTypeControl.insertSegment (withTitle: "Реципиент", at: 0, animated: true)
    donorTypeControl.insertSegment(withTitle: "Донор", at: 1, animated: true)
    
    petTypeControl.insertSegment(withTitle: "Кошка", at: 0, animated: true)
    petTypeControl.insertSegment(withTitle: "Собака", at: 1, animated: true)
    
    let views = [contactInfoLabel, descriptionLabel, bloodTypeLabel,
                 imageView, stack, bloodTypeButton,
                 descriptionText, contactInfoText]
    views.forEach() { [weak self] view in
      guard let self = self else { return }
      view.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview(view)
    }
    
    let constraints = [
      imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
      imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 200),
      
      stack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
      stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
      
      descriptionLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
      descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
      descriptionLabel.heightAnchor.constraint(equalToConstant: 50)
    ]
    constraints.forEach() {constaint in
      constaint.isActive = true
    }
  }
}
