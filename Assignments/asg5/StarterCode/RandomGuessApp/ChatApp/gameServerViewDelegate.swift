//
//  gameServerViewDelegate.swift
//  ChatApp
//
//  Created by Tabar, NicoloJanPaez on 2019-04-18.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

//TODO delegate where gameServerController makes calls to functions in gameViewController
protocol GameServerViewListenerDelegate:class {
    func exitView()
    func sendView(text: String)
    func updateView(isGameWon :Bool, name:String)
    func updateViewName(name: String)
}
