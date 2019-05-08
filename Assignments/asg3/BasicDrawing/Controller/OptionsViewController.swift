//
//  OptionsViewController.swift
//  BasicDrawing
//
//  Created by Tabar, NicoloJanPaez on 2019-02-28.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    // ===============================================================
    // Global Variables
    // ===============================================================
    var mainPage: ViewController?

    let myColours = ["blue":UIColor.blue,
                     "red":UIColor.red,
                     "green":UIColor.green,
                     "black":UIColor.black,
                     "orange":UIColor.orange,
                     "yellow":UIColor.yellow,
                     "purple":UIColor.purple,
                     ]
    
    var lineWidth = 5 {
        didSet {
            LineWidthLabel.text = String(lineWidth)
            drawPreview(bgColor: fillColor, borderColor: lineColor)
        }
    }
    
    var fillColor = UIColor.clear {
        didSet {
            drawPreview(bgColor: fillColor, borderColor: lineColor)
        }
    }

    var lineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor {
        didSet {
            drawPreview(bgColor: fillColor, borderColor: lineColor)
        }
    }
    
    var isFillSwitch = false {
        didSet {
            drawPreview(bgColor: fillColor, borderColor: lineColor)
        }
    }
    
    
    // ===============================================================
    // On load
    // ===============================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentColours(seg: LineColourChoice)
        setSegmentColours(seg: FillColourChoice)
        PreviewView.layer.borderWidth = CGFloat(lineWidth)
        
        //initialize current options with previously set options
        if mainPage != nil {
            initWithOptions()
        }
    }
    
    // ===============================================================
    // Gui Objects & Events
    // ===============================================================
    @IBOutlet weak var PreviewView: UIView!
    @IBOutlet weak var LineWidthLabel: UILabel!
    @IBOutlet weak var LineWidthSlider:UISlider!
    @IBOutlet weak var FillColourChoice: UISegmentedControl!
    @IBOutlet weak var doFillSwitch: UISwitch!
    @IBOutlet weak var LineColourChoice: UISegmentedControl!
    
    @IBAction func OKClick(_ sender: UIButton) {
        
        // send options to mainpage if initialized
        if mainPage != nil {
            mainPage!.options = Options(isFill: isFillSwitch, fill: fillColor, lineColor: lineColor, lineWidth: lineWidth)
        }
        closeWindow()
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        closeWindow()
    }
    
    @IBAction func lineWidthSliderChanged(_ sender: UISlider) {
        print(sender.value);
        lineWidth = Int(sender.value);
    }

    @IBAction func LineColourChoiceClick(_ sender: UISegmentedControl) {
        lineColor = getSegmentedColor(segment: sender).cgColor
    }
    
    @IBAction func FillColourChoiceClick(_ sender: UISegmentedControl) {
        fillColor = getSegmentedColor(segment: sender)
    }
    
    @IBAction func doFillSwitchClick(_ sender: UISwitch) {
        isFillSwitch = !isFillSwitch
    }
    
    
    // ===============================================================
    // Based on the segmented, get the color from myColours hashmap
    // returns a tuple of segmentIndex and color
    // ===============================================================
    func getSegmentedColor(segment: UISegmentedControl) -> UIColor {

        let segmentedIndex = segment.selectedSegmentIndex
        let title = segment.titleForSegment(at:segmentedIndex)!

        return myColours[title]!
    }
    
    // ============================================================
    // Dynamically create the colours for a segment control
    // ============================================================
    func setSegmentColours(seg:UISegmentedControl) {
        
        // start segmented section from scratch
        seg.removeAllSegments()
        
        // loop through all available colours and create the segment
        var segIndex = 0
        for (name,_) in myColours {
            seg.insertSegment(withTitle: "\(name)", at: segIndex, animated: false)
            segIndex=segIndex+1
        }
    }
    
    // ===============================================================
    // Display a preview of selected options
    // ===============================================================
    func drawPreview(bgColor: UIColor, borderColor: CGColor) {
        PreviewView.layer.borderColor = borderColor
        PreviewView.backgroundColor = isFillSwitch ? bgColor : UIColor.clear
        PreviewView.layer.borderWidth = CGFloat(lineWidth)
    }

    // ===============================================================
    // initialize the page with previously set options
    // ===============================================================
    func initWithOptions(){
        lineWidth = mainPage!.options.lineWidth
        lineColor = mainPage!.options.lineColor
        fillColor = mainPage!.options.fillColor
        isFillSwitch = mainPage!.options.fillSwitch
        
        initGUI()
    }
    
    // ===============================================================
    // initialize the GUI based on previously set options
    // ===============================================================
    func initGUI() {
        
        LineWidthSlider.value = Float(lineWidth)
        
        doFillSwitch.setOn(isFillSwitch, animated: true)
        
        // get index based on fill color, of dictionary
        if let index = Array(myColours.values).firstIndex(of: fillColor) {
                FillColourChoice.selectedSegmentIndex = index
        }
        
        // get index based on line color, of dictionary
        if let index = Array(myColours.values).firstIndex(of: UIColor(cgColor: lineColor)) {
            LineColourChoice.selectedSegmentIndex = index
        }
    }
    
    // ===============================================================
    // CloseWindow
    // ===============================================================
    func closeWindow() {
        dismiss(animated: true, completion: nil)
    }
}
