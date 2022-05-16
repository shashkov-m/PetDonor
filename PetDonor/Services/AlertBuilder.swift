//
//  AlertBuilder.swift
//  PetDonor
//
//  Created by Max Shashkov on 24.01.2022.
//

import UIKit

struct AlertBuilder {
  static func build(presentOn viewController: UIViewController,
                    title: String?,
                    message: String?,
                    preferredStyle: UIAlertController.Style,
                    actions: [UIAlertAction?]) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    if actions.count > 0 {
      actions.forEach { action in
        guard let action = action else { return }
        alert.addAction(action)
      }
    }
    viewController.present(alert, animated: true)
  }
}
