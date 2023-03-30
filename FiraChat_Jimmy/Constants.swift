//
//  Constants.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/23.
//

import Foundation
import FirebaseFirestore

let COLLECION_MESSAGES = Firestore.firestore().collection(K.messages)
let COLLECION_USERS = Firestore.firestore().collection(K.users)

struct K {
    static let recentMessage = "recentMessage"
    static let timestamp = "timestamp"
    static let text = "text"
    static let fromID = "fromID"
    static let toID = "toID"
    static let users = "users"
    static let messages = "messages"
   
    
    init() {}
}
