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
    // public properties
    // -----------------------------------------------------------
    var client:Client?
    var me:String = "Me"
    var myPlayerNumber = 0
    var game: gameServerController?

    
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
        sendToTextEntry.textColor = notYetColour
        guessLabel.text = ""
        game = gameServerController(client: self.client!, me: self.me, myPlayer: self.myPlayerNumber)
    }

    
    // -----------------------------------------------------------
    // start new game
    // -----------------------------------------------------------
    @IBAction func StartNewGame(_ sender: UIButton) {
        game!.randomNumberToGuess = Int(arc4random_uniform(10)) + 1
        StatusLabel.text = "sending random number"
        SendButton.isEnabled = true
    }
    
    // -----------------------------------------------------------
    // disconnect from the server
    // -----------------------------------------------------------
    @IBAction func ExitTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // -----------------------------------------------------------
    // send info to the server
    // -----------------------------------------------------------
    @IBAction func SendButtonTap(_ sender: UIButton) {
        
    }
    
    func exitView() {
        print("THIS IS EXIT VIEW")
        print("THIS IS EXIT VIEW DONE")
    }

    func sendView(text: String) {
        print("THIS IS SEND VIEW")
        print(text)
        print("THIS IS SEND VIEW DONE")
    }

    func updateView(isGameWon: Bool, name: String) {
        print("THIS IS UPDATE VIEW")
        print(isGameWon)
        print(name)
        print("THIS IS UPDATE VIEW DONE")
    }
    func updateViewName(name: String) {
        print("THIS IS UPDATE VIEW")
        print(name)
        print("THIS IS UPDATE VIEW DONE")
    }

}
