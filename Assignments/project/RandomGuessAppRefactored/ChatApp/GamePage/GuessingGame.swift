//
//  GuessingGame.swift
//  ChatApp
//
//  Created by Sandy on 2019-04-08.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

class GuessingGame {
    var numberToGuess:Int = -1            {didSet {
    print ("hello")
        }}
    var currentPlayer:Int = 0
    var isGameWon = false
    var winningPlayer = 0
    var myPlayerNumber = 0
    init() {}
    
    func setPlayerNumber(to num:Int) {
        myPlayerNumber = num
    }
    func newGame(withRandomNumber number:Int) {
        numberToGuess = number
        currentPlayer = 1
        isGameWon = false
        winningPlayer = 0
     }
    
    func gamePlay(wasGuessed guess:Int, fromPlayer player:Int)->Int {
            if guess < numberToGuess {
               return -1
            }
            else if guess > numberToGuess {
                return 1
            }
            else {
                isGameWon = true
                winningPlayer = currentPlayer
                return 0
            }
    }
    
}
