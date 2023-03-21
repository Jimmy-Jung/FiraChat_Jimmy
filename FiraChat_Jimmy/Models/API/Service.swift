//
//  Service.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/21.
//

import Foundation
import FirebaseFirestore
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
}
