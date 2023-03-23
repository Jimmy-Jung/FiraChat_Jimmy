//
//  Message.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/22.
//

import FirebaseAuth
import FirebaseFirestore

struct Message {
    let text: String
    let toID: String
    let fromID: String
    var timestamp: Timestamp!
    var user: User?
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid
    }
}
