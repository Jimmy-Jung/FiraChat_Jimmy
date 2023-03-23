//
//  Service.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Service {
    
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users: [User] = []
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let err = error {
                print("ERROR: \(err.localizedDescription)")
            }
            snapshot?.documents.forEach { document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
            }
            completion(users)
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping(([Message]) -> Void) ) {
        var message = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    message.append(Message(dictionary: dictionary))
                    completion(message)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["text": message,
                    "fromID": currentUid,
                    "toID": user.uid,
                    "timestamp": Timestamp(date: Date())] as [String: Any] as [String: Any]
        
        COLLECION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) {_ in 
            COLLECION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
        }
    }
}
