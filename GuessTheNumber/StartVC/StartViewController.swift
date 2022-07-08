//
//  StartViewController.swift
//  GuessTheNumber
//
//  Created by Алексей Авер on 06.07.2022.
//

import UIKit
enum ControllerType: Equatable {
    case guessVC
    case robotGuesses
    case humanGuesses
    case results
}
class StartViewController: GradientViewController {
    
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var biggerButton: BlueButton?
    @IBOutlet weak var smallerButton: BlueButton?
    @IBOutlet weak var dialogLabel: UILabel?
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var guessButton: BlueButton?
    private let controllerType: ControllerType
    
    init(controllerType: ControllerType) {
        self.controllerType = controllerType
        super.init(nibName: String(describing: StartViewController.self),
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.controllerType = .guessVC
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch controllerType {
            
        case .guessVC:
            [refreshButton, biggerButton, smallerButton, dialogLabel].forEach { item in
                item?.isHidden = true
            }
            self.navigationItem.title = "Загадайте число от 0 до 100"
            guessButton?.addTarget(self, action: #selector(guessTapped), for: .touchUpInside)
            
        case .robotGuesses:
            textField?.isHidden = true
            
            smallerButton?.addTarget(self, action: #selector(smallerTapped), for: .touchUpInside)
            biggerButton?.addTarget(self, action: #selector(higherTapped), for: .touchUpInside)
            
            guessButton?.removeTarget(self, action: #selector(guessTapped), for: .touchUpInside)
            guessButton?.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
            
            guessButton?.setTitle("Угадал", for: .normal)
            
            
            let number = GuessManager.shared.midrange
            dialogLabel?.text = ("Наверно это число \(number) ?")
            
        case .humanGuesses:
            [smallerButton, biggerButton].forEach { button in
                button?.isHidden = true
            }
            self.dialogLabel?.text = "Как ты думаешь, какое число я загадал?"
            guessButton?.setTitle("Проверить", for: .normal)
            guessButton?.addTarget(self, action: #selector(checkNumber), for: .touchUpInside)
            
        case .results:
            [smallerButton, biggerButton, guessButton, textField].forEach { item in
                item?.isHidden = true
            }
            GuessManager.shared.whoWinner { result in
                self.dialogLabel?.text = ("""
 \(result)
Попыток компьютера: \(GuessManager.shared.appAttempts)
Ваших попыток: \(GuessManager.shared.humanAttempts)
"""
                )
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshButton?.addTarget(self, action: #selector(reset), for: .touchUpInside)
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor("000000").withAlphaComponent(0.5),
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10, weight: .regular)
        ]
        textField?.attributedPlaceholder = NSAttributedString(string: "Введите число", attributes: attributes)
        self.hideKeyboardWhenTappedAround()
    }
    
    //MARK: - guessVC
    
    
    @objc private func guessTapped() {
        guard let int: Int = textField?.text?.intValue,
              let textString = textField?.text,
              !textString.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите число от 0 до 100")
            return
        }
        let textLength = textString.count
        if textLength > 3 || int > 100 {
            showAlert(title: "Ошибка", message: "Введите число от 0 до 100")
        } else {
            GuessManager.shared.guessedNumber = int
            
            let appguessVC = StartViewController(controllerType: .robotGuesses)
            if #available(iOS 13.0, *) {
                appguessVC.isModalInPresentation = true
            } else {
                navigationController?.pushViewController(appguessVC, animated: true)
            }
            present(appguessVC, animated: true)
        }
    }
    
    //MARK: - ROBO
    @objc private func rightTapped() {
        GuessManager.shared.rigthGuess { [self] bool in
            if !bool {
                self.showErrorAlert()
                return
            } else {
                self.dialogLabel?.text = ("А теперь загадываю я")
                [self.biggerButton, self.smallerButton].forEach { button in
                    button?.isHidden = true
                }
                self.guessButton?.setTitle("Давай", for: .normal)
                self.guessButton?.removeTarget(self, action: #selector(rightTapped), for: .touchUpInside)
                self.guessButton?.addTarget(self, action: #selector(gotoHumanGuess), for: .touchUpInside)
                
            }
        }
    }
    
    @objc private func smallerTapped() {
        
        GuessManager.shared.guessLowNumber { int, bool in
            if !bool {
                self.showErrorAlert()
                return
            } else {
                guard let int = int else {
                    return
                }
                self.dialogLabel?.text = ("Наверно это число \(int) ?")
            }
        }
    }
    
    @objc private func higherTapped() {
        GuessManager.shared.guessHigherNumber{ int,bool in
            if !bool {
                self.showErrorAlert()
                return
            } else {
                guard let int = int else {
                    return
                }
                self.dialogLabel?.text = ("Наверно это число \(int) ?")
            }
        }
    }
    
    //MARK: - HUMAN
    @objc private func gotoHumanGuess() {
        GuessManager.shared.guess()
        
        let appguessVC = StartViewController(controllerType: .humanGuesses)
        if #available(iOS 13.0, *) {
            appguessVC.isModalInPresentation = true
        } else {
            navigationController?.pushViewController(appguessVC, animated: true)
        }
        present(appguessVC, animated: true)
        
    }
    
    @objc private func checkNumber() {
        guard let int: Int = textField?.text?.intValue,
              let textString = textField?.text,
              !textString.isEmpty else {
            showAlertWithoutBack()
            return
        }
        let textLength = textString.count
        if textLength > 3 || int > 100 {
            showAlertWithoutBack()
        } else {
            GuessManager.shared.humanCheck(num: int) { [self] bool, num in
                if !bool {
                    switch num {
                    case 0:
                        self.dialogLabel?.text = ("Больше!")
                        return
                    case 1:
                        self.dialogLabel?.text = ("Меньше!")
                        return
                    default: return
                    }
                } else {
                    if bool {
                        self.dialogLabel?.text = ("Вы угадали! Это число \(GuessManager.shared.guessedNumber)")
                        self.guessButton?.setTitle("Дальше", for: .normal)
                        self.guessButton?.removeTarget(self, action: #selector(self.checkNumber), for: .touchUpInside)
                        self.guessButton?.addTarget(self, action: #selector(goToResults), for: .touchUpInside)
                        
                    }
                }
            }
        }
    }
    
    @objc private func goToResults() {
        let resultsVC = StartViewController(controllerType: .results)
        if #available(iOS 13.0, *) {
            resultsVC.isModalInPresentation = true
        } else {
            navigationController?.pushViewController(resultsVC, animated: true)
        }
        present(resultsVC, animated: true)
    }
    
    
    //MARK: - OTHER
    func showAlertWithoutBack() {
        let alert = UIAlertController(title: "Ошибка", message: "ВВедите число от 0 до 100", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true)
    }
    
    func showErrorAlert() {
        showAlert(title: "Кажется, ты ошибся", message: "Вернемся назад")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.dismiss(animated: true) {
                GuessManager.shared.reset()
            }
        }))
        self.present(alert, animated: true)
    }
    
    @objc private func reset() {
        GuessManager.shared.reset()
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
