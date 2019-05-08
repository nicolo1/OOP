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
            //TODO: let view know number of players changed
            self.mainPage!.updatePlayersChangedUpdateView(numberOfPlayers: self.numberOfPlayers, me: self.me, you: self.you)
        }
        
        // TODO: INIT CONNECT 4 GAME DATA TO SEND TO SERVER SHOULD GO HERE
        if parts[0] == "randomNumber" {
            /* TODO
            1. SEND TO CLIENT RECEIVED DATA
            2. UPDATE VIEW
             */
        }
        
        // TODO: RECEIVED INIT CONNECT 4 GAME DATA TO SERVER SHOULD GO HERE
        if parts[0] == "ranNumReceived" {
            /* TODO
             1. UPDATE VIEW THAT GAME STARTED
             2. INIT CONNECT 4 GAME
             3. VIEW DIFFERENT FOR BOTH CHARACTERS
             */
        }
        
        // someone took a guess, now its the others turn // TODO: PLAYER PLAYED A TOKEN
        if parts[0] == "guess" {
            /* TODO
            1. GET TOKEN POSITION
            2. CHECK WIN CONDITION
            3. UPDATE VIEW
            self.currentPlayer = self.currentPlayer % 2 + 1
            4. UPDATE VIEW BASED ON CURRENT PLAYER
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
        /* TODO
         1. INITIALIZE GAME
         2. SEND INITIALIZE DATA
         3. UPDATE VIEW
         */
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

        /* TODO
         1. CHECK WHO'S TURN IT IS
         2. THIS IS WHERE USER'S INPUT GOES AND SENT TO SERVER
         */
    }
}
