//
//  ViewController.swift
//  Assignment4
//
//  Created by Tabar, NicoloJanPaez on 2019-03-29.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        scores = Score.getAll();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "leaderboardModally" {
            let leaderboardPage =  segue.destination as! LeaderboardViewController
            leaderboardPage.mainPage = self
        }
    }
    
    // ===============================================================
    // Global Variables
    // ===============================================================
    var MAX_SIZE = 10
    
    var name: String = "" {
        didSet {
            toggle_btn(isValid: check_text_fields())
        }
    }
    
    var score: String = "" {
        didSet {
            toggle_btn(isValid: check_text_fields())
        }
    }

    var scores = [Score]() {
        didSet {
            
            // sort list of scores by score
            self.scores.sort { (score1, score2) -> Bool in
                
                // tie breaker, sort by name
                if score1.score == score2.score {
                    return score1.name < score2.name
                }
                
                // scores are ordered in descending order
                return score1.score > score2.score
            }
            
            // delete scores when size exceeds limit
            while self.scores.count > MAX_SIZE {
                
                // scores in descending order, deletes lowest
                self.scores.last?.delete()
                
                // remove deleted score from array
                self.scores.removeLast()
            }
        }
    }
    
    // ===============================================================
    // Outlets & Actions
    // ===============================================================
    @IBOutlet weak var name_text_outlet: UITextField!
    @IBOutlet weak var score_text_outlet: UITextField!
    @IBOutlet weak var add_btn_outlet: UIButton!
    
    // action for when user enters character in score text field
    @IBAction func score_text_field_edit(_ sender: UITextField) {
        score = sender.text!
    }
    
    // action for when user enters character in name text field
    @IBAction func name_text_field_edit(_ sender: UITextField) {
        name = sender.text!;
    }
    @IBAction func add_btn(_ sender: UIButton) {
        scores.append(Score(name: name, score: Int(score)!))
        performSegue(withIdentifier: "leaderboardModally", sender: sender)
    }
    
    @IBAction func view_btn(_ sender: UIButton) {
        performSegue(withIdentifier: "leaderboardModally", sender: sender)
    }

    @IBAction func cancel_btn(_ sender: UIButton) {
        clearText()
    }

    /* @function check_text_fields
     * @description checks if name and score textfields are empty
     * @params none
     * @return Bool, true if non-empty, false otherwise
     */
    public func check_text_fields() -> Bool {
        return (name != "" && score != "")
    }
    
    /* @function toggle_btn
     * @description enables/disables add button based on validation
     * @params none
     * @return void
     */
    public func toggle_btn(isValid: Bool) {
        add_btn_outlet.isEnabled = isValid;
        add_btn_outlet.isUserInteractionEnabled = isValid;
    }
    
    /* @function clearText
     * @description clears the name and score textbox
     * @params none
     * @return void
     */
    public func clearText() {
        self.name_text_outlet.text = ""
        self.score_text_outlet.text = ""
    }
}
