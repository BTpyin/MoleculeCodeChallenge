//
//  BaseNavigationController.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 18/4/2021.
//

import UIKit

class BaseNavigationController: UINavigationController {
      var router: Router? {
        didSet {
          // Pass the router into TopViewController
          if let topVC = topViewController as? BaseViewController {
            topVC.router = router
          }
            
        }
      }

      override func viewDidLoad() {
        super.viewDidLoad()

        
      }

      override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
      }
}

