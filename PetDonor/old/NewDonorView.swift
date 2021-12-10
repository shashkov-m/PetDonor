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
  let descriptionText = UITextView ()
  let contactInfoText = UITextView ()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .systemBackground
    configureConstraints()
    configureViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureViews () {
    imageView.image = UIImage (named: "photo_2021-12-02 18.29.33")
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 20
    
    descriptionLabel.text = "Описание :"
    contactInfoLabel.text = "Контактные данные :"
    bloodTypeLabel.text = "Группа крови :"
    
    donorTypeControl.insertSegment (withTitle: "Реципиент", at: 0, animated: true)
    donorTypeControl.insertSegment(withTitle: "Донор", at: 1, animated: true)
    
    petTypeControl.insertSegment(withTitle: "Кошка", at: 0, animated: true)
    petTypeControl.insertSegment(withTitle: "Собака", at: 1, animated: true)
    
    bloodTypeButton.setTitle("выберите", for: .normal)
    bloodTypeButton.backgroundColor = .black
    let typeA = UIAction (title: "A") { _ in
      
    }
    let menu = UIMenu (title: "", options: .displayInline, children:[typeA])
    bloodTypeButton.menu = menu
    bloodTypeButton.showsMenuAsPrimaryAction = true
    
    //descriptionText.backgroundColor = .gray
    
    //contactInfoText.backgroundColor = .gray
    
  }
  
  private func configureConstraints () {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    //imageView.frame = CGRect (x: 0, y: 0, width: 200, height: 200)
    let donorPetStack = UIStackView (arrangedSubviews: [donorTypeControl, petTypeControl])
    donorPetStack.axis = .horizontal
    donorPetStack.distribution = .fillEqually
    donorPetStack.spacing = 20
    
    let bloodTypeStack = UIStackView (arrangedSubviews: [bloodTypeLabel, bloodTypeButton])
    bloodTypeStack.axis = .horizontal
    bloodTypeStack.distribution = .fillProportionally
    
    let descriptionStack = UIStackView (arrangedSubviews: [descriptionLabel, descriptionText])
    descriptionStack.axis = .vertical
    descriptionStack.distribution = .fillProportionally
    
    let contactStack = UIStackView (arrangedSubviews: [contactInfoLabel, contactInfoText])
    contactStack.axis = .vertical
    contactStack.distribution = .fillProportionally
    
    let stack = UIStackView () //(arrangedSubviews: [donorPetStack, descriptionStack,
                            //                    bloodTypeStack, contactStack])
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.spacing = 20
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(imageView)
    //self.addSubview(stack)
    
    let constraints = [
      imageView.topAnchor.constraint(equalTo: self.topAnchor),
      imageView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 1)
//      imageView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: 20),
      
//      stack.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
//      stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
//      stack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ]
    
    constraints.forEach { constr in
      constr.isActive = true
    }
  }
}
