//
//  gameServerViewDelegate.swift
//  ChatApp
//
//  Created by Tabar, NicoloJanPaez on 2019-04-18.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

protocol GameServerViewListenerDelegate:class {    
    func updateSendText(text: String)
    func updateViewStatus(text:String)
    func updateGuess(guess: String)
    func updatePlayersChangedUpdateView(numberOfPlayers: Int, me: String, you: String)
    func updateViewBasedOnCurrentPlayer(isGameWon: Bool, myPlayerTurn: Int, currentPlayerTurn: Int, you: String)
    func updateViewStartGame(status: String, isEnabled: Bool)
    func updateViewName(name: String)
    func updateViewError(message: String)
}
