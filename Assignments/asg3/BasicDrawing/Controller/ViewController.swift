//
//  ViewController.swift
//  BasicDrawing
//
//  Created by Tabar, NicoloJanPaez on 2019-02-28.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // ===============================================================
    // Global Variables
    // ===============================================================
    var options = Options() {
        didSet {
            canvasView.currentOptions = options
        }
    }
    
    @IBOutlet weak var canvasView: CanvasView!

    // ===============================================================
    // Overriden Function
    // ===============================================================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "optionsModally" {
            let optionsPage =  segue.destination as! OptionsViewController
            optionsPage.mainPage = self
        }
    }
    
    // ===============================================================
    // Get the selected shape
    // ===============================================================
    @IBAction func shapeChosen(_ sender: UISegmentedControl) {
        canvasView.selectedShape = sender.selectedSegmentIndex;
        print(canvasView.selectedShape)
    }
}

