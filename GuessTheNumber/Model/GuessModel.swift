//
//  GuessModel.swift
//  GuessTheNumber
//
//  Created by Алексей Авер on 06.07.2022.
//

import Foundation

class GuessManager: NSObject {
    static let shared = GuessManager()
    
    var humanAttempts = Int()
    var appAttempts = Int()
    var guessedNumber = Int()
    var lowRange = 0
    var highRange = 100
    var midrange = 50
    var count = 1
    
    
    func guessLowNumber(completion: @escaping (Int?, Bool) -> Void) {
        highRange = midrange
        midrange = (lowRange + highRange) / 2
        count += 1
        if highRange < guessedNumber || highRange == guessedNumber {
            reset()
            completion(nil, false)
        } else {
            completion(midrange, true)
        }
    }
    
    
    func guessHigherNumber(completion: @escaping (Int?, Bool) -> Void) {
        
        lowRange = midrange
        midrange = (lowRange + highRange) / 2
        if lowRange == midrange || midrange != 100 {
//            midrange += 1
        }
        count += 1
        if lowRange > guessedNumber || lowRange == guessedNumber {
            reset()
            completion(nil, false)
        } else {
            completion(midrange, true)
        }
    }
    
    func rigthGuess(completion: @escaping (Bool) -> Void) {
        if midrange != guessedNumber {
            reset()
            completion(false)
        } else {
            appAttempts = count
            guess()
            completion(true)
        }
    }
    
    func guess() {
        lowRange = 0
        highRange = 100
        midrange = 50
        count = 1
        guessedNumber = Int.random(in: 0...100)
    }
    
    func reset() {
        lowRange = 0
        highRange = 100
        midrange = 50
        humanAttempts = 0
        appAttempts = 0
        guessedNumber = 0
        count = 1
    }
    
    func humanCheck(num: Int, completion: @escaping (Bool, Int?) -> Void) {
        if num == guessedNumber {
            completion(true, nil)
            humanAttempts = count
            return
        } else {
            if num > guessedNumber {
                completion(false, 1)
                count += 1
            } else {
                completion(false, 0)
                count += 1
            }
        }
    }
    
    
    func whoWinner(completion: @escaping (String) -> Void) {
        if humanAttempts == appAttempts {
           completion("Ничья!")
        } else {
            let humanWinner: Bool = humanAttempts < appAttempts
            completion(humanWinner ? "Вы выиграли!" : "Выиграл компьютер")
        }
    }
    
}
