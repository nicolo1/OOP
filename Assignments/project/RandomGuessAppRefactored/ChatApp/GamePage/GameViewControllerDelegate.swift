//
//  GameViewControllerDelegate.swift
//  ChatApp
//
//  Created by Sandy on 2019-04-08.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation
protocol GameViewControllerDelegate:class {
    func updateError(onError error:String)
    func updateNumberOfPlayers(to num:Int)
    func updateReceivedRandomNumber(number num:Int)
    func updateCurrentPlayerChanged()
    func update(forPlayer player:String, withGuess guess:Int, andResult result:Int)
    func update(winnerIs player:String, withGuess number:Int)
    func updateReadyToPlay(_ flag:Bool)
}
