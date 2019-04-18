//
//  gameServerController.swift
//  ChatApp
//
//  Created by Tabar, NicoloJanPaez on 2019-04-18.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

class gameServerController: ClientServerListenerDelegate {
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO dont forget to make delegate lazy to avoid circular reference, only uses it when you need it
        client?.listenerDelegate = self
    }
    */

    var mainPage: GameViewController?

    // -----------------------------------------------------------
    // public properties
    // -----------------------------------------------------------
    var client:Client?
    
    var me:String = "Me"
    var myPlayerNumber = 0
    var game: guessingGame?
    
    // -----------------------------------------------------------
    // global variables related to the game
    // -----------------------------------------------------------
    var you = "You"
    
    var currentPlayer = 0
    var myTurn:Bool {return myPlayerNumber == currentPlayer}
    
    var randomNumberToGuess:Int = -1 {
        didSet {
            // WHENEVER RANDOM NUMBER IS SET, ADD TO OUTPUT QUEUE
        }
    }
    var numberOfPlayers = 0
    
    var isGameWon = false
    
    init (client: Client, me: String, myPlayer: Int) {
        self.client = client
        self.me = me
        self.myPlayerNumber = myPlayer
        self.client?.listenerDelegate = self
    }
    
    // -----------------------------------------------------------
    // client (that's me) has connected
    // -----------------------------------------------------------
    func clientListenerDidConnect(asPlayer num: Int, andName name: String) {
        // playerLabel.text = me
        // myPlayerNumber = num
    }
    // ----------------------------------------------------
    // any error, just bail out (so sad)
    // ----------------------------------------------------
    func clientListenerReceived(errorString error: String) {
        client?.closeSocket()
        // dismiss(animated: true, completion: nil)
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
            // playerLabel.text = "\(me) vs \(you)"
        }
        
        // this is the random number we need to guess
        if parts[0] == "randomNumber" {
            randomNumberToGuess = Int(parts[1]) ?? -1
            client?.addToOutputQueue(thisData: "ranNumReceived:\(randomNumberToGuess)")
            // StatusLabel.text = "Ready to play, waiting for \(you)"
        }
        
        // we have received the random number
        if parts[0] == "ranNumReceived" {
            currentPlayer = 1
            // SendButton.isEnabled = true
            isGameWon = false
            // updateViewBaseOnCurrentPlayer()
            // guessLabel.text = ""
        }
        
        // someone took a guess, now its the others turn
        if parts[0] == "guess" {
            let guess = Int(parts[1]) ?? -1
            // processGuess(forPlayer: currentPlayer, withGuess: guess)
            currentPlayer = currentPlayer % 2 + 1
            if (self.game!.isGameOver(baseOnCurrentGuess:guess)) {
                currentPlayer = 0
                isGameWon = true
            }
            //updateViewBaseOnCurrentPlayer()
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
    
    func startGame() {
        let ran = Int(arc4random_uniform(10)) + 1
        client?.addToOutputQueue(thisData: "randomNumber:\(ran)")
    }
    
    func exitGame() {
        client?.closeSocket()
    }
    
    func sendToServer(text: String) {
        if myTurn {
            
            // validate for valid integer
            let myNum = Int(text) ?? -1
            if myNum > -1 {
                client?.addToOutputQueue(thisData: "guess:\(myNum)")
                // sendToTextEntry.text = ""
            }
            // else {
                // sendToTextEntry.textColor = notYetColour
                // StatusLabel.text = "you must send an integer"
            // }
        }
    }
}
