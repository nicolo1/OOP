//
//  gameServerController.swift
//  ChatApp
//
//  Created by Tabar, NicoloJanPaez on 2019-04-18.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

class gameServerController: ClientServerListenerDelegate {
    var mainPage: GameViewController?
    var game: guessingGame?

    // -----------------------------------------------------------
    // public properties
    // -----------------------------------------------------------
    var client:Client?
    var me:String = "Me"
    var myPlayerNumber = 0
    
    
    // -----------------------------------------------------------
    // global variables related to the game
    // -----------------------------------------------------------
    var isGameWon = false
    var you = "You"
    var currentPlayer = 0
    var myTurn:Bool {return self.myPlayerNumber == self.currentPlayer}
    var randomNumberToGuess:Int = -1
    var numberOfPlayers = 0 {
        didSet {
            mainPage!.updatePlayersChangedUpdateView(numberOfPlayers: self.numberOfPlayers, me: self.me, you: self.you)
        }
    }
    
    init (client: Client, me: String, myPlayer: Int, mainPage: GameViewController) {
        self.client = client
        self.me = me
        self.myPlayerNumber = myPlayer
        self.client?.listenerDelegate = self
        self.mainPage = mainPage
        self.game = guessingGame()
    }
    
    // -----------------------------------------------------------
    // client (that's me) has connected
    // -----------------------------------------------------------
    func clientListenerDidConnect(asPlayer num: Int, andName name: String) {
        self.mainPage!.updateViewName(name: name)
    }
    
    // ----------------------------------------------------
    // any error, just bail out (so sad)
    // ----------------------------------------------------
    func clientListenerReceived(errorString error: String) {
        client?.closeSocket()
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
            //self.mainPage!.updateViewPlayersChanged() // TODO: let view know number of players changed
        }
        
        // this is the random number we need to guess // TODO: INIT CONNECT 4 GAME DATA TO SEND TO SERVER SHOULD GO HERE
        if parts[0] == "randomNumber" {
            // TODO: send to client the received data
            self.mainPage!.updateViewStatus(text:"Ready to play, waiting for \(you)")
        }
        
        // we have received the random number // TODO: RECEIVED INIT CONNECT 4 GAME DATA TO SERVER SHOULD GO HERE
        if parts[0] == "ranNumReceived" {
            // TODO: UPDATE VIEW THAT GAME STARTED
            // TODO: INIT CONNECT 4 GAME
            // TODO: VIEW DIFFERENT FOR BOTH CHARACTERS
        }
        
        // someone took a guess, now its the others turn // TODO: PLAYER PLAYED A TOKEN
        if parts[0] == "guess" {
            /*
            1. GET TOKEN POSITION
            let result = self.game!.processGuess(guesser: self.myTurn ? self.me : self.you, withGuess: guess) // CHECK WIN CONDITION
            self.mainPage!.updateGuess(guess: result) // UPDATE VIEW
            self.currentPlayer = self.currentPlayer % 2 + 1
            if (self.game!.isGameOver(baseOnCurrentGuess:guess)) {
                self.currentPlayer = 0
                self.isGameWon = true
            }
            self.mainPage!.updateViewBasedOnCurrentPlayer(isGameWon: self.isGameWon, myPlayerTurn: self.myPlayerNumber, currentPlayerTurn: self.currentPlayer, you: self.you)
             */
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
    // Start Game
    // ----------------------------------------------------
    func startGame() {
        self.randomNumberToGuess = Int(arc4random_uniform(10)) + 1
        self.client?.addToOutputQueue(thisData: "randomNumber:\(self.randomNumberToGuess)")
        self.mainPage!.updateViewStartGame(status: "sending random number", isEnabled: true)
    }
    
    // ----------------------------------------------------
    // Exit Game
    // ----------------------------------------------------
    func exitGame() {
        self.client?.closeSocket()
    }
    
    // ----------------------------------------------------
    // User clicked send button, send data to server
    // ----------------------------------------------------
    func sendToServer(guess: String) {
        
        if validateNumber(text: guess) {
            let number = Int(guess)!
            if self.myTurn {
                self.client?.addToOutputQueue(thisData: "guess:\(number)")
                self.mainPage!.updateSendText(text: "")
            }
        } else {
            self.mainPage!.updateViewError(message: "you must send an integer")
        }
    }
    
    // -----------------------------------------------------------
    // Validate that text is a valid integer
    // -----------------------------------------------------------
    func validateNumber(text: String) -> Bool {
        let myNum = Int(text) ?? -1
        if myNum <= -1 {
            return false
        }
        return true
    }
}
