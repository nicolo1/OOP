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
        // Do any additional setup after loading the view, typically from a nib.
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
            toggle_btn()
        }
    }
    
    var score: String = "" {
        didSet {
            toggle_btn()
        }
    }

    var scores = [Score]() {
        didSet {
            // tableView.reloadData();
            
            // sort list of scores by score
            self.scores.sort { (score1, score2) -> Bool in
                
                // tie breaker, sort by name
                if score1.score == score2.score {
                    return score1.name < score2.name
                }
                return score1.score > score2.score
            }
            
            while self.scores.count > MAX_SIZE {
                self.scores.last?.delete()
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
    @IBAction func score_text_field_edit(_ sender: UITextField) {
        score = sender.text!
    }
    @IBAction func name_text_field_edit(_ sender: UITextField) {
        name = sender.text!;
    }
    @IBAction func add_btn(_ sender: UIButton) {
        scores.append(Score(name: name, score: Int(score)!))
        performSegue(withIdentifier: "leaderboardModally", sender: sender)
    }
    
    @IBAction func view_btn(_ sender: UIButton) {
        performSegue(withIdentifier: "leaderboardModally", sender: sender)
        // TODO: ask sandy how to use the same segue for two buttons the way she thought us to do it
        
    }

    @IBAction func cancel_btn(_ sender: UIButton) {
        clearText()
    }
    /* @function is_empty
     * @description checks if provided variable is empty
     * @params textField
     * @return Bool, true if valid, false otherwise
     */
    public func is_empty(value: String) -> Bool {
        return value == "";
    }
    
    /* @function toggle_btn
     * @description enables/disables add button based on validation
     * @params none
     * @return void
     */
    public func toggle_btn() {
        
        // check if values of textboxes arent empty
        if !is_empty(value: name) && !is_empty(value: score) {
            
            // check score is valid integer
            if  let intScore = Int(score), intScore >= 0 {
                add_btn_outlet.isEnabled = true;
                add_btn_outlet.isUserInteractionEnabled = true;
            } else {
                add_btn_outlet.isEnabled = false;
                add_btn_outlet.isUserInteractionEnabled = false;
            }
            
            
        } else {
            add_btn_outlet.isEnabled = false;
            add_btn_outlet.isUserInteractionEnabled = false;
        }
    }
    
    public func clearText() {
        self.name_text_outlet.text = ""
        self.score_text_outlet.text = ""
    }
    
    /* @function
     * @description
     * @params
     * @return
     */
}
