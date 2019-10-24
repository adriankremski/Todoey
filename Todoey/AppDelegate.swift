//
//  AppDelegate.swift
//  Todoey
//
//  Created by Adrian Kremski on 30/09/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let loginManager = FirebaseAuthManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        if (!loginManager.isLoggedIn()) {
            showLoginPage()
        } else {
            showMainPage()
        }

        return true
    }

    func showLoginPage() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: LandingScreenViewController(nibName: "LandingScreenViewController", bundle: nil))
        window?.makeKeyAndVisible()
    }
    
    func showMainPage() {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "mainViewController")
        window!.rootViewController = centerVC
        window!.makeKeyAndVisible()
    }
}

