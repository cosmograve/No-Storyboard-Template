//
//  Router.swift
//  GuessTheNumber
//
//  Created by Алексей Авер on 06.07.2022.
//

import UIKit

class Router: NSObject {
    @objc static let shared = Router()
    
    private override init() {
        super.init()
        
        
    }
    
    func showStartVC() {
        let frame = UIScreen.main.bounds
        let startVC = BaseNavigationViewController(rootViewController: StartViewController(controllerType: .guessVC))
        let window = UIWindow(frame: frame)
        window.rootViewController = startVC
        window.makeKeyAndVisible()
        window.alpha = 0
        UIView.animate(withDuration: 0.25) {
            window.alpha = 1
        } completion: { (_) in
            AppDelegate.appDelegate.window = window
            
        }
    }
}
