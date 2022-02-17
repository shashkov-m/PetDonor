//
//  AuthView.swift
//  PetDonor
//
//  Created by Max Shashkov on 30.12.2021.
//

import UIKit

class AuthView: UIView {
  lazy var signInButton:UIButton = {
    let signInButton = UIButton ()
    var signInButtonConfiguration = UIButton.Configuration.filled ()
    signInButtonConfiguration.title = "Войти"
    signInButton.configuration = signInButtonConfiguration
    return signInButton
  } ()
  
  lazy var signUpButton:UIButton = {
    let signUpButton = UIButton ()
    var signUpButtonConfiguration = UIButton.Configuration.filled ()
    signUpButtonConfiguration.title = "Регистрация"
    signUpButton.configuration = signUpButtonConfiguration
    return signUpButton
  } ()
  
  lazy var backgroundImage:UIImageView = {
    let backgroundImage = UIImageView ()
    backgroundImage.translatesAutoresizingMaskIntoConstraints = false
    if traitCollection.userInterfaceStyle == .dark {
      backgroundImage.image = UIImage (named: "catBackgroundWhite")
    } else {
      backgroundImage.image = UIImage (named: "catBackgroundBlack")
    }
    return backgroundImage
  } ()
  
  lazy var stack:UIStackView = {
    let stack = UIStackView (arrangedSubviews: [signInButton, signUpButton])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 20.0
    return stack
  } ()
  
  override init(frame: CGRect) {
    super .init(frame: frame)
    viewConfigure()
    constraintsConfigure ()
  }
  required init?(coder: NSCoder) {
    super .init(coder: coder)
    viewConfigure()
    constraintsConfigure ()
  }
  
  private func viewConfigure () {
    backgroundColor = .systemBackground
    addSubview(stack)
    addSubview(backgroundImage)
  }
  
  private func constraintsConfigure () {
    NSLayoutConstraint.activate ([
      stack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                    constant: -40),
      stack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                     constant: 20),
      stack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                      constant: -20),
      backgroundImage.heightAnchor.constraint(equalToConstant: 100),
      backgroundImage.widthAnchor.constraint(equalToConstant: 100),
      backgroundImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      backgroundImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }
}
