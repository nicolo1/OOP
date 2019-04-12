//
//  LeaderboardViewController.swift
//  Assignment4
//
//  Created by Tabar, NicoloJanPaez on 2019-03-29.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mainPage != nil {
            self.scores = mainPage!.scores
        }
    }
    
    // ===============================================================
    // Global Variables
    // ===============================================================
    let WINNER_EMOJI: String = "👑"
    
    var mainPage: ViewController?
    
    var scores = [Score]()
 
    @IBAction func btn_dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)

    }
 
    // ===============================================================
    // TableView functions
    // ===============================================================
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scores.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // scores are in descending order, first score is the highest
        if indexPath.row == 0 {
            
            // set highest score with cell with icon
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithIcon", for: indexPath) as! TableViewCellWithIcon
            cell.icon_label?.text = ("\(WINNER_EMOJI)")
            cell.name_label?.text = ("\(self.scores[indexPath.row].name)")
            cell.score_label?.text = String(self.scores[indexPath.row].score)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithoutIcon", for: indexPath) as! TableViewCellWithoutIcon
        cell.name_label?.text = self.scores[indexPath.row].name
        cell.score_label?.text = String(self.scores[indexPath.row].score)
        
        return cell
    }
}
