//
//  LeaderboardViewController.swift
//  Assignment4
//
//  Created by Tabar, NicoloJanPaez on 2019-03-29.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let WINNER_EMOJI: String = "👑"
    var mainPage: ViewController?
    
    var scores = [Score]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mainPage != nil {
            self.scores = mainPage!.scores
        }
    }    
 
    @IBAction func btn_dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scores.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
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
