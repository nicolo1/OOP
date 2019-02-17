//
//  ViewController.swift
//  assigment2
//
//  Created by Tabar, NicoloJanPaez on 2019-01-31.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//
// ---- ---- SOURCE FOR MY EXTRA ---- ----
// https://medium.com/anantha-krishnan-k-g/how-to-add-faceid-touchid-using-swift-4-a220db360bf4

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    // constants ---- ---- ---- ---- ---- ----
    let THEME = [0,1,2,3,4,5]
    let THEME_BG_COLOR = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
    let THEME_FG_COLOR = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    let THEME_CARD_FRONT_COLOR = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    let THEME_CARD_BACK_COLOR = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]

    let SUCCESS_AUTH = true
    let RESET_AUTH = false
    
    // global variables ---- ---- ---- ---- ---- ----
    var emojiChoices = ["👶", "🧒", "👦", "🧓", "👵", "👩", "🧔", "👳‍♂️"]
    var emoji = [Int:String]()
    var currTheme = 0
    var score = 0
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRoundCorners(cardButtons)
        self.setRoundCorners([newGameButton])
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet var mainView: UIView!
    
    @IBOutlet var StackViews: [UIStackView]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    // event handler for choosing new game ---- ---- ---- ---- ---- ---- ----
    @IBAction func touchNewGame(_ sender: Any) {
        
        // prompts touchID from user
        touchIdAction()
    }
    
    //variable that is changed based on user authentication
    var authentication = false {
        didSet{
            
            //check if user authentication passed
            if(authentication == SUCCESS_AUTH){
               resetGame()
            }
        }
    }
    
    // set rounded corners for buttons ----- ----- ----- ----- -----
    func setRoundCorners(_ objects:[UIButton]){
        
        //round all objects in collection
        for object in objects{
            object.layer.cornerRadius = object.frame.size.width / 10
            object.layer.masksToBounds = true
        }
    }
    
    // event handler for choosing a card ---- ---- ---- ---- ---- ---- ----
    @IBAction func touchCard(_ sender: Any) {
        let btn = sender as! UIButton
        
        //check what card was selected
        if let cardNumber = cardButtons.index(of: btn) {
            game.chooseCard(at: cardNumber)
            score += game.checkScore(at: cardNumber)
            updateViewFromModel()
        } else {
            print ("chosen card was not in cardButtons")
        }
        
        if game.isFinish() {
            gameOver()
        }
    }
    
    // event handler when user must authenticate using touchID ---- ---- ---- ---- ---- ---- ----
    func touchIdAction(){
        
        touchIdActionHelper(
            //callback function called when user has made an authentication request
            completion: { (result: Bool) in
            
            //check user authentication
            if result {
                self.authentication = self.SUCCESS_AUTH
            }else {
                self.authentication = self.RESET_AUTH
            }
        })
    }
    
    //helper function to touchIdAction() ---- ---- ---- ---- ---- ---- ----
    func touchIdActionHelper(completion: @escaping (_ : Bool) -> Void) {
        print("Authentication to start new game")
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Authentication to start new game."
        var authError: NSError?
        
        //check if device is compatible with touch ID
        if #available(iOS 8.0, macOS 10.12.1, *) {
            
            //check if user enabled touchID on device
            if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                
                /* ---- ---- CONTEXT FOR myContext.evaluatePolicy() ---- ----
                 Since myContext.evaluatePolicy() is asynchronous, the following code is done in a different closure. This means any modifications I make are made on a different thread.
                 For example, my first instinct was to return true and use that value elsewhere in my code block. This didn't work. I cannot return true since it isn't on the main thread, so it instead returned a "Unexpected non-void return value in void function" error. The value true would only be returned from that closure, and this error is saying that said closure must return a void.
                 After doing a bit of research, I found that I had to use a callback function called once the background thread has finished processing. This is what DispatchQueue.main.async does, it waits until the main thread is ready to be processed. When it is ready, it executes its code block.
                 */
                
                //async call that validates users touch ID
                //if touchID fails, prompt passcode authentication
                myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    //goes back to main thread to perform user interface
                    DispatchQueue.main.async {
                        if success {
                            print("User authenticated successfully.")
                            
                            //callback function
                            completion(true)
                        } else {
                            print ("User did not authenticate successfully.")
                        }
                    }
                }
            } else {
                print ("Sorry... Could not evaluate policy.")
            }
        } else {
            print ("Sorry... Device does not support touch ID.")
        }
        
        //user not successfully authenticated
        completion(false)
    }
    
    // update view model ---- ---- ---- ---- ---- ---- ----
    func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                
                //display emoji on card
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                
                if card.isMatched {
                    button.backgroundColor = THEME_BG_COLOR[currTheme]
                }else {
                    button.backgroundColor = THEME_CARD_FRONT_COLOR[currTheme]
                }
                
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0): THEME_CARD_BACK_COLOR[currTheme]
            }
        }
        
        scoreLabel.text = "Score: " + String(score)
    }
    
    //resets the game ---- ---- ---- ---- ---- ----
    func resetGame(){
        
        //randomly select the theme
        currTheme = Int.random(in: 0 ..< 6)
        game.reset()
        score = 0
        
        for _ in cardButtons.indices {
            emoji = [Int:String]()
        }
        
        //enable all cards
        for index in StackViews.indices{
            StackViews[index].alpha = 1
            StackViews[index].isUserInteractionEnabled = true
        }
        
        chooseTheme()
        scoreLabel.alpha = 1
        updateViewFromModel()
    }
    
    // display game over screen ---- ---- ---- ---- ---- ---- ----
    func gameOver(){
        updateViewFromModel()
        
        //disable all cards
        for index in StackViews.indices{
            StackViews[index].isUserInteractionEnabled = false
        }
        
        scoreLabel.text = "Final Score: " + String(score)
    }
    
    // emoji ---- ---- ---- ---- ---- ---- ----
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
    // randomly chooses emoji theme ---- ---- ---- ---- ---- ---- ----
    func emojiTheme() -> [String]{
        switch currTheme {
        case THEME[0]:
            return ["👶", "🤴", "👦", "🧓", "👵", "👩", "🧔", "👳‍♂️"]
        case THEME[1]:
            return ["👶🏻", "🤴🏻", "👦🏻", "🧓🏻", "👵🏻", "👩🏻", "🧔🏻", "👳🏻"]
        case THEME[2]:
            return ["👶🏼", "🤴🏼", "👦🏼", "🧓🏼", "👵🏼", "👩🏼", "🧔🏼", "👳🏼"]
        case THEME[3]:
            return ["👶🏽", "🤴🏽", "👦🏽", "🧓🏽", "👵🏽", "👩🏽", "🧔🏽", "👳🏽"]
        case THEME[4]:
            return ["👶🏾", "🤴🏾", "👦🏾", "🧓🏾", "👵🏾", "👩🏾", "🧔🏾", "👳🏾"]
        case THEME[5]:
            return ["👶🏿", "🤴🏿", "👦🏿", "🧓🏿", "👵🏿", "👩🏿", "🧔🏿", "👳🏿"]
        default:
            return ["😂", "😅", "😆", "😎", "😏", "😜", "😤", "🤧"]
        }
    }
    
    // randomly selects theme ---- ---- ---- ---- ---- ---- ----
    func chooseTheme(){
        mainView.backgroundColor = THEME_BG_COLOR[currTheme]
        
        scoreLabel.textColor = THEME_FG_COLOR[currTheme]
        newGameButton.backgroundColor = THEME_CARD_BACK_COLOR[currTheme]
        newGameButton.setTitleColor(THEME_FG_COLOR[currTheme], for: UIControl.State.normal)
        emojiChoices = emojiTheme()
    }
}
