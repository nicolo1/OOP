//
//  ViewController.swift
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

class GameViewController: UIViewController,ClientServerListenerDelegate {
    
    // -----------------------------------------------------------
    // public properties
    // -----------------------------------------------------------
    var client:Client?
    var me:String = "Me"
    var myPlayerNumber = 0
    
    // -----------------------------------------------------------
    // global variables related to the game
    // -----------------------------------------------------------
    private var you = "You"
    
    private var currentPlayer = 0
    private var myTurn:Bool {return myPlayerNumber == currentPlayer}
    
    private var randomNumberToGuess:Int = -1
    private var numberOfPlayers = 0 {didSet { numPlayersChangedUpdateView() }}
    
    private var isGameWon = false
    
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
        // TODO dont forget to make delegate lazy to avoid circular reference, only uses it when you need it
        client?.listenerDelegate = self
        sendToTextEntry.textColor = notYetColour
        guessLabel.text = ""
    }
    
    // -----------------------------------------------------------
    // client (that's me) has connected
    // -----------------------------------------------------------
    func clientListenerDidConnect(asPlayer num: Int, andName name: String) {
        playerLabel.text = me
        myPlayerNumber = num
    }
    
    
    // -----------------------------------------------------------
    // start new game
    // -----------------------------------------------------------
    @IBAction func StartNewGame(_ sender: UIButton) {
        let ran = Int(arc4random_uniform(10)) + 1
        client?.addToOutputQueue(thisData: "randomNumber:\(ran)")
        StatusLabel.text = "sending random number"
        SendButton.isEnabled = true
        isGameWon = false
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
        if myTurn {
            let myNum = Int(sendToTextEntry.text!) ?? -1
            if myNum > -1 {
                client?.addToOutputQueue(thisData: "guess:\(myNum)")
                sendToTextEntry.text = ""
            }
            else {
                sendToTextEntry.textColor = notYetColour
                StatusLabel.text = "you must send an integer"
            }
        }
    }
    
    // ----------------------------------------------------
    // any error, just bail out (so sad)
    // ----------------------------------------------------
    func clientListenerReceived(errorString error: String) {
        client?.closeSocket()
        dismiss(animated: true, completion: nil)
    }
    
    // ----------------------------------------------------
    // we got data from the server... what to do? ... what to do?
    // ----------------------------------------------------
    func clientListenerReceived(rawData: String) {
        let receivedData = ClientReceivedData(rawData: rawData)
        
        switch receivedData.dataType {
            
        case .listenerConnectionNumbers:
            numberOfPlayers = Int(receivedData.userData) ?? 0
            
        case .listenerDisconnection: break
            
        case .connectionOrListenerError: clientListenerReceived(errorString: receivedData.userData)
            
        case .listenerSomeoneConnected: someBodyConnected(userData:receivedData)
            
        case .listenerUserdata: processUserData(receivedData)
        default:break // stuff that isn't applicable to me
        }
    }
    
    // ----------------------------------------------------
    // somebody connected
    // ----------------------------------------------------
    func someBodyConnected (userData data:ClientReceivedData) {
        if myPlayerNumber != data.player {
            you = data.username
            client?.addToOutputQueue(thisData: "iam:\(me)")
        }
    }
    
    // ----------------------------------------------------
    // process user data
    // ----------------------------------------------------
    func processUserData(_ data:ClientReceivedData) {
        let parts = getTwoComponents(str: data.userData)
        
        // the other player is letting me know who they are
        if parts[0] == "iam" {
            if myPlayerNumber != data.player {
                you = parts[1]
            }
            else {
                me = parts[1]
            }
            playerLabel.text = "\(me) vs \(you)"
        }
        
        // this is the random number we need to guess
        if parts[0] == "randomNumber" {
            randomNumberToGuess = Int(parts[1]) ?? -1
            client?.addToOutputQueue(thisData: "ranNumReceived:\(randomNumberToGuess)")
            StatusLabel.text = "Ready to play, waiting for \(you)"
        }
        
        // we have received the random number
        if parts[0] == "ranNumReceived" {
            currentPlayer = 1
            SendButton.isEnabled = true
            isGameWon = false
            updateViewBaseOnCurrentPlayer()
            guessLabel.text = ""
        }
        
        // someone took a guess, now its the others turn
        if parts[0] == "guess" {
            let guess = Int(parts[1]) ?? -1
            processGuess(forPlayer: currentPlayer, withGuess: guess)
            currentPlayer = currentPlayer%2 + 1
            if (isGameOver(baseOnCurrentGuess:guess)) {
                currentPlayer = 0
                isGameWon = true
            }
            updateViewBaseOnCurrentPlayer()
        }
    }
    
    // ----------------------------------------------------
    // update view depending on whose turn it is
    // ----------------------------------------------------
    func updateViewBaseOnCurrentPlayer() {
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
    
    
    // ----------------------------------------------------
    // break the user Data into two parts
    // ----------------------------------------------------
    func getTwoComponents(str:String)->[String] {
        var results = [String]()
        let components = str.split(separator: ":", maxSplits: 1)
        for index in components.indices {
            results.append(String(components[index]))
        }
        return results
    }
    
    // ----------------------------------------------------
    // process the guess
    // ----------------------------------------------------
    func processGuess(forPlayer player:Int, withGuess guess:Int) {
        var result = ""
        var who = you
        if myTurn {
            who = me
        }
        if guess < randomNumberToGuess {
            result = "\(who) guessed \(guess) but it is too low"
        }
        else if guess > randomNumberToGuess {
            result = "\(who) guessed \(guess) but it is too high"
        }
        else {
            result = "\(who) guessed \(guess) correctly"
        }
        guessLabel.text = result
    }
    
    // ----------------------------------------------------
    // is game over
    // ----------------------------------------------------
    func isGameOver(baseOnCurrentGuess guess: Int)->Bool {
        return guess == randomNumberToGuess
    }
    
    // ----------------------------------------------------
    // update the view when number of players changes
    // ----------------------------------------------------
    func numPlayersChangedUpdateView() {
        if numberOfPlayers == 2 {
            NewGameButton.isEnabled = true
            StatusLabel.text = ""
            playerLabel.text = "\(me) vs \(you)"
        }
        else {
            StatusLabel.text = "waiting for another player to connect"
            NewGameButton.isEnabled = false
            playerLabel.text = "\(me)"
            SendButton.isEnabled = false
            guessLabel.text = ""
        }
    }
    
    
    
}
