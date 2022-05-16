//
//  UIView+ShakeAnimation.swift
//  PetDonor
//
//  Created by Max Shashkov on 15.01.2022.
//

import UIKit

extension UIView {
  func applyShakeAnimation () {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    animation.duration = 0.6
    animation.values = [-15.0, 15.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
    self.layer.add(animation, forKey: "transform.translation.x")
  }
}
