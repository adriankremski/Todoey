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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        // 1
        let storyboard = UIStoryboard(name: "Login", bundle: .main)

        // 2
        if let initialViewController = storyboard.instantiateInitialViewController() {
            // 3
            window?.rootViewController = initialViewController
            // 4
            window?.makeKeyAndVisible()
        }

        return true
    }

}

