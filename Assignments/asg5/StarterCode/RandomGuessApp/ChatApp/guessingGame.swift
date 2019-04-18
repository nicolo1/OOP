//
//  guessingGame.swift
//  ChatApp
//
//  Created by Tabar, NicoloJanPaez on 2019-04-18.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

class guessingGame {
    private var randomNumberToGuess:Int = -1
    init(randomNumberToGuess: Int) {
        self.randomNumberToGuess = randomNumberToGuess
    }
    
    // ------------------------------------------------------
    // process the guess
    // ------------------------------------------------------
    public func processGuess(guesser: String , withGuess guess:Int) -> String {
        if guess < self.randomNumberToGuess {
            return "\(guesser) guessed \(guess) but it is too low."
        }
        else if guess > self.randomNumberToGuess {
            return "\(guesser) guessed \(guess) but it is too high."
        }
        else {
            return "\(guesser) guessed \(guess) correctly!"
        }
    }
    
    public func isGameOver(baseOnCurrentGuess guess: Int)->Bool {
        return guess == randomNumberToGuess
    }
}
