//
//  ViewController.swift
//  ChatApp
//
//  Created by Sandy on 2019-04-01.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit
protocol GameViewDelegate {
    func updateView()
}

class ViewController: UIViewController, GameViewControllerDelegate  {
    
    // -----------------------------------------------------------
    // public properties
    // -----------------------------------------------------------
    var client:Client?

    // -----------------------------------------------------------
    // global variables related to the game
    // -----------------------------------------------------------
    private let gameServer = GameServerController()
    func updateError(onError error: String) {
        
    }

    
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
    // initialize view
    // -----------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        gameServer.client = client        
        client?.listenerDelegate = gameServer
        sendToTextEntry.textColor = notYetColour
        gameServer.viewDelegate = self
        guessLabel.text = ""
    }


    // -----------------------------------------------------------
    // start new game
    // -----------------------------------------------------------
    @IBAction func StartNewGame(_ sender: UIButton) {
        StatusLabel.text = "sending random number"
        SendButton.isEnabled = true
        gameServer.StartNewGame()
    }

    // -----------------------------------------------------------
    // disconnect from the server
    // -----------------------------------------------------------
    @IBAction func ExitTap(_ sender: UIButton) {
        client?.closeSocket()
        dismiss(animated: true, completion: nil)
    }
    
    // -----------------------------------------------------------
    // send info to the server
    // -----------------------------------------------------------
    @IBAction func SendButtonTap(_ sender: UIButton) {
        if gameServer.myTurn {
            let myNum = Int(sendToTextEntry.text!) ?? -1
            if myNum > -1 {
                gameServer.send(guess: myNum)
                sendToTextEntry.text = ""
            }
            else {
                sendToTextEntry.textColor = notYetColour
                StatusLabel.text = "you must send an integer"
            }
        }
    }

    func updateNumberOfPlayers(to num: Int) {
        playerLabel.text = ""
        StatusLabel.text = ""
        if num == 1 {
            playerLabel.text = gameServer.me
            StatusLabel.text = "Waiting for another player to join"
            guessLabel.text = ""
            NewGameButton.isEnabled = false
            
        }
        else if num == 2 {
            playerLabel.text = "\(gameServer.me) vs \(gameServer.you)"
            StatusLabel.text = "Click New Game to play"
            NewGameButton.isEnabled = true
        }
    }
    
    func updateReceivedRandomNumber(number num: Int) {
        NewGameButton.isEnabled = true
        guessLabel.text = ""
    }
    
    
    func updateCurrentPlayerChanged() {
        if (gameServer.myTurn) {
            StatusLabel.text = "It's my turn, I'm gonna guess"
            sendToTextEntry.textColor = okColour
        }
        else {
            StatusLabel.text = "It's \(gameServer.you)'s turn to guess"
            sendToTextEntry.textColor = notYetColour
        }
    }
    
    func update(forPlayer player:String, withGuess guess:Int, andResult result:Int) {
        var statement = "equals"
        if result < 0 {
            statement = "too low"
        }
        else if result > 0 {
            statement = "too high"
        }
        let user = gameServer.myTurn ? gameServer.me : gameServer.you
        guessLabel.text = "\(user) guessed \(guess) and it was \(statement)"

    }
    
    func update(winnerIs player: String, withGuess number:Int) {
        guessLabel.text = "\(player) guessed \(number) correctly"
        StatusLabel.text = "GAME OVER"
        sendToTextEntry.textColor = notYetColour
    }
    
    func updateReadyToPlay(_ flag:Bool) {
        SendButton.isEnabled = flag
    }


    
    
    
    
    
    
    
    
    // ----------------------------------------------------
    // update view depending on whose turn it is
    // ----------------------------------------------------
/*    func updateViewBaseOnCurrentPlayer() {
        if isGameWon {
           StatusLabel.text = "GAME OVER"
        }
        else {
        if myPlayerNumber == currentPlayer {
            StatusLabel.text = "It's my turn, I'm gonna take a guess"
            sendToTextEntry.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            StatusLabel.text = "waiting for \(you)"
            sendToTextEntry.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        }
        
    }
    
  */
    
    
}
