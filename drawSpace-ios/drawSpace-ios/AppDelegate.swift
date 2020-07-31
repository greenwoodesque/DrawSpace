//
//  AppDelegate.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/28/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = .black
        return true
    }

}

