//
//  AppDelegate.swift
//  SwiftCellContentHeightAnimation
//
//  Created by Monster on 2017-01-25.
//  Copyright © 2017 Monster. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = MZViewController()
        window?.makeKeyAndVisible()
        
        return true
    }


}

