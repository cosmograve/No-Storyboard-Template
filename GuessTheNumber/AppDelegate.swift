//
//  AppDelegate.swift
//  templateNoStoryboard
//
//  Created by Алексей Авер on 03.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    


}

