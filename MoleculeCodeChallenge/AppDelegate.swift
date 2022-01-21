//
//  AppDelegate.swift
//  MoleculeCodeChallenge
//
//  Created by Bowie Tso on 17/4/2021.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import Firebase
import FirebaseAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setATT()
        if #available(iOS 13.0, *) {
            let navbarAppearance = UINavigationBarAppearance()
            navbarAppearance.configureWithTransparentBackground()
            navbarAppearance.shadowImage = UIImage()
            navbarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navbarAppearance.backgroundColor = UIColor(named: "themeColor")
            UINavigationBar.appearance().standardAppearance = navbarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navbarAppearance
            UINavigationBar.appearance().compactAppearance = navbarAppearance
        }
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["4675eb4d85b45838199da6591d14bd63"]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        setATT()
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func setATT() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .notDetermined:
                    NSLog("notDetermined")
                case .restricted:
                    NSLog("restricted")
                case .denied:
                    NSLog("denied")
                case .authorized:
                    NSLog("authorized")
                @unknown default:
                    NSLog("unknown")
                }
            }
        }
    }
    
    
}

