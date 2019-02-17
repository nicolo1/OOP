//
//  ViewController.swift
//  Assignment1
//
//  Created by Tabar, NicoloJanPaez on 2019-01-24.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRoundCorners(btnRound)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet var btnRound: [UIButton]!
    
    @IBOutlet weak var numberLabel: UILabel!
    //global variables
    var number = "0" {
        didSet{
            if(numberLabel.text == "0"){
                numberLabel.text = ("\(number)")
            }else{
                //append number to label whenever the user selects a number
                numberLabel.text = ("\(numberLabel.text!)\(number)")
            }
        }
    }
    
    func setRoundCorners(_ objects:[UIButton]){
        for object in objects{
            //object.layer.borderColor = UIColor.blue
            object.layer.cornerRadius = object.frame.size.width / 5
            object.layer.masksToBounds = true
        }
    }
    
    var isResult = false
    
    //clears the label
    @IBAction func touchClear(_ sender: UIButton) {
        clearLabel()
    }
    
    //squares the number inside the label
    @IBAction func touchSqr(_ sender: UIButton) {
        let numToSqr = Int(numberLabel.text!)
        numberLabel.text = String(numToSqr! * numToSqr!)
        isResult = true
    }
    
    //places number to label
    @IBAction func touchNumber(_ sender: UIButton) {
        
        //clear the label if the user has squared a number previously
        if isResult{
            clearLabel()
            isResult = false
        }
        number = sender.title(for: UIControl.State.normal)!
    }
    
    func clearLabel(){
        numberLabel.text = "0"
    }
}

