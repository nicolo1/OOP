//
//  Score.swift
//  Assignment4
//
//  Created by Tabar, NicoloJanPaez on 2019-03-29.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import Foundation
import UIKit
import CoreData


struct Score {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate;
    static var DBContext = appDelegate.persistentContainer.viewContext;

    // ===============================================================
    // Constructor
    // ===============================================================
    init(name: String, score: Int) {
        self.currentScore = ScoreEntity(context: Score.DBContext);
        self.currentScore.name = name;
        self.currentScore.score = Int32(score);
        saveChanges();
    }
    
    init(scoreEntity: ScoreEntity) {
        self.currentScore = scoreEntity
        saveChanges();
    }
    
    
    // ===============================================================
    // Properties
    // ===============================================================
    public var name: String {
        return self.currentScore.name != nil ? self.currentScore.name! : "";
    }
    public var score: Int {
        
        return Int(self.currentScore.score);
    }
    
    private var currentScore: ScoreEntity;
    
    // ===============================================================
    // Functions
    // ===============================================================
    private func saveChanges() {
        do {
            try Score.DBContext.save();
        } catch {
            print("Error Saving: \(error.localizedDescription)");
        }
    }
    
    public static func getAll() -> [Score] {
        var scores = [Score]();
        
        // create the fetch request statement
        let fetchRequest: NSFetchRequest<ScoreEntity> = ScoreEntity.fetchRequest();
        
        do {
            
            // fetch from database based on fetch statement
            for scoreEntity in try DBContext.fetch(fetchRequest) {
                scores.append(Score(scoreEntity: scoreEntity));
            }
        } catch {
            print("Error fetching: \(error.localizedDescription)");
        }
        
        return scores;
    }
    
    
    public func delete() {
        Score.DBContext.delete(currentScore);
        saveChanges();
    }
    
    public func modify(name: String, score: Int) {
        self.currentScore.name = name;
        self.currentScore.score = Int32(score);
        saveChanges();
    }
}
