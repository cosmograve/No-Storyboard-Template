//
//  ViewController.swift
//  templateNoStoryboard
//
//  Created by Алексей Авер on 03.07.2022.
//

import UIKit

class ViewController: GradientViewController {

    @IBOutlet weak var startButton: BlueButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton?.addTarget(self, action: #selector(goToStart), for: .touchUpInside)
        

    }
    @objc private func goToStart() {
        Router.shared.showStartVC()
    }

}

