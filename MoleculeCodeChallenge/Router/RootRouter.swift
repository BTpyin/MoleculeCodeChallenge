//
//  RootRouter.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 18/4/2021.
//

import UIKit

class RootRouter: Router{
    
    //use root router to show screen
    
    func showStart(animated: Bool, complete: (() -> Void)? = nil ){
        guard
          let startViewController = UIStoryboard.storyboard(.main).instantiateViewController(StartViewController.self) else {
            return
        }
        //        let homeNavigationController = BaseNavigationController.init(rootViewController: homeViewController)
        startViewController.router = self
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    //        homeViewController.modalPresentationStyle = .fullScreen
        startViewController.navigationController?.navigationBar.backItem?.hidesBackButton = false
        startViewController.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(startViewController, animated: false)
    }
}
