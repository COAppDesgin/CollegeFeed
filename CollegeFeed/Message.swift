//
//  Message.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/24/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    
    init(dictionary: [String: Any]) {
        self.fromID = dictionary["fromID"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.toID = dictionary["toID"] as? String
    }
    
    func chatPartnerID() -> String? {
        return (fromID! == (Auth.auth().currentUser?.uid)! ? toID : fromID)!
    }
    
}
