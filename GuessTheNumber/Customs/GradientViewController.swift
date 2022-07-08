//
//  GradientViewController.swift
//  GuessTheNumber
//
//  Created by Алексей Авер on 06.07.2022.
//

import UIKit

class GradientViewController: UIViewController {
    
    let gradient = CAGradientLayer()
    
    let color1 = UIColor("ffafbd").cgColor
    let color2 = UIColor("ffc3a0").cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGradient()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        gradient.frame = view.bounds
    }
    
    private func makeGradient() {
        gradient.colors = [color1, color2]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        view.layer.insertSublayer(gradient, at: 0)
        
    }
    
}
