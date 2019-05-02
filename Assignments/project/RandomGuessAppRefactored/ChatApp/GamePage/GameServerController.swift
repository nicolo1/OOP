//
//  GuessingGameServerController.swift
//  ChatApp
//
//  Created by Sandy on 2019-04-08.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

class GameServerController: ClientServerListenerDelegate {
    
    var client:Client?
    private var game:GuessingGame = GuessingGame()
    weak var viewDelegate:GameViewControllerDelegate?
    
    // -----------------------------------------------------------
    // public properties
    // -----------------------------------------------------------
    var me:String = "Me"
    var you:String = "You"
    var myPlayerNumber = 0
    
    // -----------------------------------------------------------
    // global variables related to the game
    // -----------------------------------------------------------
    private var currentPlayer = 0
    var myTurn:Bool {return myPlayerNumber == currentPlayer}
    
    private var randomNumberToGuess:Int = -1
    private var numberOfPlayers = 0
    
    // -----------------------------------------------------------
    // start new game
    // -----------------------------------------------------------
    func StartNewGame() {
        let ran = Int(arc4random_uniform(10)) + 1
        client?.addToOutputQueue(thisData: "randomNumber:\(ran)")
    }
    
    // -----------------------------------------------------------
    // disconnect from the server
    // -----------------------------------------------------------
    func disconnectFromSocket() {
        client?.closeSocket()
    }
    
    // -----------------------------------------------------------
    // send guess to the server
    // -----------------------------------------------------------
    func send(guess num:Int) {
        if myTurn {
            client?.addToOutputQueue(thisData: "guess:\(num)")
        }
    }
    
    // -----------------------------------------------------------
    // client (that's me) has connected
    // -----------------------------------------------------------
    func clientDidConnect(asPlayer num: Int, andName name: String) {
        myPlayerNumber = num
        me = name
    }
    
    // ----------------------------------------------------
    // we got data from the server... what to do? ... what to do?
    // ----------------------------------------------------
    func clientReceived(rawData data: String) {
        let receivedData = ClientReceivedData(rawData: data)
        
        switch receivedData.dataType {
            
        case .listenerConnectionNumbers:
            numberOfPlayers = Int(receivedData.userData) ?? 0
            viewDelegate?.updateNumberOfPlayers(to: numberOfPlayers)
            
        case .connectionOrListenerError:
            clientReceivedError(errorString: receivedData.userData)
            
        case .listenerSomeoneConnected:
            if myPlayerNumber != receivedData.player {
                you = receivedData.username
                client?.addToOutputQueue(thisData: "iam:\(me)")
            }
            
        case .listenerUserdata:
            processUserData(receivedData)
            
        default:break // stuff that isn't applicable to me
        }
    }
    func clientReceivedError(errorString error: String) {
        client?.closeSocket()
        viewDelegate?.updateError(onError: error)
        
    }


    // ----------------------------------------------------
    // process user data
    // ----------------------------------------------------
    func processUserData(_ data:ClientReceivedData) {
        let userData = UserReceivedData(username:data.username,userData:data.userData)
        
        switch userData.dataType {
            
        // the other player is letting me know who they are
        case .iam:
            if myPlayerNumber != data.player {
                you = userData.username
            }
            else {
                me = userData.username
            }
            viewDelegate?.updateNumberOfPlayers(to: numberOfPlayers)
        
        // this is the random number we need to guess
        case .randomNumber:
            randomNumberToGuess = Int(userData.data) ?? -1
            client?.addToOutputQueue(thisData: "ranNumReceived:\(randomNumberToGuess)")
        
        // we have received the random number
        case .ranNumReceived:
            randomNumberToGuess = Int(userData.data) ?? -1
            game.newGame(withRandomNumber: randomNumberToGuess)
            currentPlayer = 1
            viewDelegate?.updateReceivedRandomNumber(number: randomNumberToGuess)
            viewDelegate?.updateCurrentPlayerChanged()
            viewDelegate?.updateReadyToPlay(true)
        
        // someone took a guess, now its the others turn
        case .guess:
            let guess = Int(userData.data) ?? -1
            let result = game.gamePlay(wasGuessed: guess, fromPlayer: currentPlayer)
            viewDelegate?.update(forPlayer:data.username, withGuess:guess, andResult:result)
            
            currentPlayer = currentPlayer%2 + 1
            viewDelegate?.updateCurrentPlayerChanged()
            
            if game.isGameWon {
                currentPlayer = 0
                viewDelegate?.update(winnerIs: data.username, withGuess:guess)
            }
        }
    }
    
    
    
    
    
}
