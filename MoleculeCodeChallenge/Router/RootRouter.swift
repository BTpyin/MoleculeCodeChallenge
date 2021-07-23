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
    
    func show48Hours(animated: Bool, complete: (() -> Void)? = nil ){
        guard
          let hourlyForecastViewController = UIStoryboard.storyboard(.main).instantiateViewController(HourlyForecastViewController.self) else {
            return
        }
        //        let homeNavigationController = BaseNavigationController.init(rootViewController: homeViewController)
        hourlyForecastViewController.router = self
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    //        homeViewController.modalPresentationStyle = .fullScreen
        hourlyForecastViewController.navigationController?.navigationBar.backItem?.hidesBackButton = false
        hourlyForecastViewController.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(hourlyForecastViewController, animated: false)
    }
    
    func show7Days(animated: Bool, complete: (() -> Void)? = nil ){
        guard
          let dailyForecastViewController = UIStoryboard.storyboard(.main).instantiateViewController(DailyForecastViewController.self) else {
            return
        }
        //        let homeNavigationController = BaseNavigationController.init(rootViewController: homeViewController)
        dailyForecastViewController.router = self
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    //        homeViewController.modalPresentationStyle = .fullScreen
        dailyForecastViewController.navigationController?.navigationBar.backItem?.hidesBackButton = false
        dailyForecastViewController.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(dailyForecastViewController, animated: false)
    }
}
