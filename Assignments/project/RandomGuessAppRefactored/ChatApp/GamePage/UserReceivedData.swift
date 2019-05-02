//
//  UserReceivedData.swift
//  ChatApp
//
//  Created by Sandy on 2019-04-09.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation
// =====================================================
// this is data structure of user data, parsed from
// usesr data sent by the server
// ======================================================
class UserReceivedData {
    
    // ========================================================
    // properties
    // =======================================================
    var rawData:String
    var username:String
    var data:String = ""
    var dataType:userDataType = .guess
    init (username:String, userData:String) {
        self.username = username
        self.rawData = userData
        parse(userData)
    }
    
    // =======================================================
    // data type enum (what kind of data did we get?)
    // =======================================================
    
    enum userDataType:String {
        case guess
        case ranNumReceived
        case randomNumber
        case iam
    }
    
    
    // =======================================================
    // the parsing bit
    // =======================================================
    private func parse(_ userData:String) {
    
        let parts = getTwoComponents(str:userData)
        self.data = parts[1]
        
        // the other player is letting me know who they are
        if parts[0] == "iam" {
            self.dataType = .iam
        }
    
        // this is the random number we need to guess
        if parts[0] == "randomNumber" {
            self.dataType = .randomNumber
        }
    
        // we have received the random number
        if parts[0] == "ranNumReceived" {
            self.dataType = .ranNumReceived
        }
    
        // someone took a guess, now its the others turn
        if parts[0] == "guess" {
            self.dataType = .guess
        }
    }

    // ----------------------------------------------------
    // break the user Data into two parts
    // ----------------------------------------------------
    func getTwoComponents(str:String)->[String] {
        var results = [String]()
        let components = str.split(separator: ":", maxSplits: 1)
        for index in components.indices {
            results.append(String(components[index]))
        }
        return results
}
}
