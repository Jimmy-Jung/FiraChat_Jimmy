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
    var charPartnerId: String? {
        return isFromCurrentUser ? toID : fromID
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary[K.text] as? String ?? ""
        self.toID = dictionary[K.toID] as? String ?? ""
        self.fromID = dictionary[K.fromID] as? String ?? ""
        self.timestamp = dictionary[K.timestamp] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    let user: User
    let message: Message
//    let profileMessage:
}
