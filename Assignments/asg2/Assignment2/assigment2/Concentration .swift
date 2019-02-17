//
//  Concentration .swift
//  assigment2
//
//  Created by Tabar, NicoloJanPaez on 2019-02-01.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import Foundation

class Concentration{
    let CHECK_WIN = 16
    let SEEN_THRESHOLD = 2
    
    var cards = [Card]()
    
    //keep track if a single card is currently flipped on the board
    var indexOfOneAndOnlyFaceUpCard: Int?
    var indexOfSecondFacedUpCard: Int?
    var numTouched = 0
    
    //event when user selects a card ---- ---- ---- ---- ---- ---- ----
    func chooseCard(at index: Int) {
        cards[index].wasSeen = cards[index].wasSeen + 1
        numTouched = numTouched + 1
        

        //ignore all matched cards
        if !cards[index].isMatched {
            
            //if a single card is faced up, check if what was selected is not the faced up card
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                
                //check for match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                cards[index].isFaceUp = true
                indexOfSecondFacedUpCard = matchIndex
                indexOfOneAndOnlyFaceUpCard = nil
            }else{
                //either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
                indexOfSecondFacedUpCard = nil
            }
        }
    }
    
    // check match ---- ---- ---- ---- ---- ---- ----
    func checkMatch(first index: Int, second matchIndex: Int) -> Bool{
        return cards[index].isMatched && cards[matchIndex].isMatched
    }
    
    // checks scores ---- ---- ---- ---- ---- ---- ----
    func checkScore(at index: Int) -> Int{
        
        //only modify score if there is at least a card faced up
        if let matchIndex = indexOfSecondFacedUpCard {
            
            //check for match
            if checkMatch(first:index, second:matchIndex) {
                return 2
            }
            
            //check if card was previously seen
            if cards[index].wasSeen >= SEEN_THRESHOLD {
                
                //check for match
                if checkMatch(first:index, second:matchIndex) {
                    return 2
                }
                
                //check if both cards were previously seen
                if cards[matchIndex].wasSeen >= SEEN_THRESHOLD {

                    //check for match
                    if checkMatch(first:index, second:matchIndex) {
                        return 2
                    }
                    return -2
                }
                return -1
            }
            //check if both cards were previously seen
            if cards[matchIndex].wasSeen >= SEEN_THRESHOLD {
                return -1
            }
        }
        
        return 0
    }
    
    init(numberOfPairsOfCards: Int){
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    //reset each card ---- ---- ---- ---- ---- ---- ----
    func reset(){

        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].wasSeen = 0
        }
        indexOfOneAndOnlyFaceUpCard = nil
        //cards.shuffle()
    }
    
    //checks if game is finished ---- ---- ---- ---- ---- ---- ----
    func isFinish() -> Bool {
        
        //only start checking win conditions once user selected the minimum number of cards
        if numTouched >= CHECK_WIN {
            
            //check if all cards are matched
            for index in cards.indices {
                if !cards[index].isMatched {
                    return false
                }
            }
            gameOver()
            return true
        }
        return false
    }
    
    //faces all cards up ---- ---- ---- ---- ---- ---- ----
    private func gameOver() {
        for index in cards.indices {
            cards[index].isFaceUp = true
        }
    }
}
