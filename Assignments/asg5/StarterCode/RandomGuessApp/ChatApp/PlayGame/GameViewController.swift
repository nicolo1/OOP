//
//  GameViewController.swift
//  ChatApp
//
//  Created by Sandy on 2019-04-01.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit
// ==========================================================
// NB: ClientReceivedData class file is in "MakeConnection"
//     folder
// ==========================================================

class GameViewController: UIViewController, GameServerViewListenerDelegate {
    
    // -----------------------------------------------------------
    // Public properties
    // -----------------------------------------------------------
    var client:Client?
    var me:String = "Me"
    var myPlayerNumber = 0
    var game: gameServerController?
    var userGuess: String = ""
    
    // -----------------------------------------------------------
    // UI related global vars
    // -----------------------------------------------------------
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var NewGameButton: UIButton!
    
    @IBOutlet weak var sendToTextEntry: UITextField!
    @IBOutlet weak var playerLabel: UILabel!
    let notYetColour:UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    let okColour:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    // -----------------------------------------------------------
    // Initialize view
    // -----------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        game = gameServerController(client: self.client!, me: self.me, myPlayer: self.myPlayerNumber, mainPage: self)
    }

    
    // -----------------------------------------------------------
    // Start new game
    // -----------------------------------------------------------
    @IBAction func StartNewGame(_ sender: UIButton) {
        game!.startGame()
    }
    
    // -----------------------------------------------------------
    // Exits the game
    // -----------------------------------------------------------
    @IBAction func ExitTap(_ sender: UIButton) {
        game!.exitGame()
        dismiss(animated: true, completion: nil)
    }
    
    // -----------------------------------------------------------
    // Send guess, validate number
    // -----------------------------------------------------------
    @IBAction func SendButtonTap(_ sender: UIButton) {
        if validateNumber(text: self.userGuess) {
            self.game!.sendToServer(number: Int(self.userGuess)!)
        } else {
            updateViewError(message: "you must send an integer")
        }
        
    }
    
    // -----------------------------------------------------------
    // Guess edit event
    // -----------------------------------------------------------
    @IBAction func guess_text_field_edit(_ sender: UITextField) {
        self.userGuess = sender.text!
    }
    
    // -----------------------------------------------------------
    // Validate that text is a valid integer
    // -----------------------------------------------------------
    func validateNumber(text: String) -> Bool {
        let myNum = Int(self.userGuess) ?? -1
        if myNum < -1 {
            return false
        }
        return true
    }
    
    // ----------------------------------------------------
    // Update the view when number of players changes
    // ----------------------------------------------------
    func updatePlayersChangedUpdateView(numberOfPlayers: Int, me: String, you: String) {
        if numberOfPlayers == 2 {
            StatusLabel.text = ""
            NewGameButton.isEnabled = true
            playerLabel.text = "\(me) vs \(you)"
            guessLabel.text = ""
        }
        else {
            SendButton.isEnabled = false
            StatusLabel.text = "waiting for another player to connect"
            NewGameButton.isEnabled = false
            playerLabel.text = "\(me)"
            guessLabel.text = ""
        }
    }

    // -----------------------------------------------------------
    // Updates the status based on text
    // -----------------------------------------------------------
    func updateViewStatus(text:String) {
        StatusLabel.text = text
    }
    
    // ----------------------------------------------------
    // Update view depending on whose turn it is
    // ----------------------------------------------------
    func updateViewBasedOnCurrentPlayer(isGameWon: Bool, myPlayerTurn: Int, currentPlayerTurn: Int, you: String) {
        if isGameWon {
            StatusLabel.text = "GAME OVER"
        }
        else {
            if myPlayerTurn == currentPlayerTurn {
                StatusLabel.text = "It's my turn, I'm gonna take a guess"
                sendToTextEntry.textColor = okColour
            }
            else {
                StatusLabel.text = "waiting for \(you)"
                sendToTextEntry.textColor = notYetColour
            }
        }
    }
    
    // ----------------------------------------------------
    // Update guess label based on current players guess
    // ----------------------------------------------------
    func updateGuess(guess: String) {
        guessLabel.text = guess
    }

    // ----------------------------------------------------
    // Update when game starts
    // ----------------------------------------------------
    func updateViewStartGame(status: String, isEnabled: Bool) {
        StatusLabel.text = status
        SendButton.isEnabled = isEnabled
        guessLabel.text = ""
    }

    // ----------------------------------------------------
    // Update player name
    // ----------------------------------------------------
    func updateViewName(name: String) {
        playerLabel.text = me
    }
    
    // ----------------------------------------------------
    // Update error message based on error
    // ----------------------------------------------------
    func updateViewError(message: String) {
        sendToTextEntry.textColor = notYetColour
        StatusLabel.text = message
    }
    
    // ----------------------------------------------------
    // Update guessing text field
    // ----------------------------------------------------
    func updateSendText(text: String) {
        sendToTextEntry.text = text
    }
}
