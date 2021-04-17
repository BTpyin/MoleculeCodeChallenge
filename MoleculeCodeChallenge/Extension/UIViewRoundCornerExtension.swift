//
//  UIViewExtension.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 17/4/2021.
//

import UIKit

extension UIView {
  func roundCorners(cornerRadius: Double) {
    self.layer.cornerRadius = CGFloat(cornerRadius)
    self.clipsToBounds = true
  }
  
}
