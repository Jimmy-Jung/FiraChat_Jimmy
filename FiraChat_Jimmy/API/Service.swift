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
        COLLECION_USERS.getDocuments { snapshot, error in
            if let err = error {
                print("ERROR: \(err.localizedDescription)")
            }
            guard var users = snapshot?.documents.map({ User(dictionary: $0.data()) }) else {return}
            
//            if let i = users.firstIndex(where: { $0.uid == Auth.auth().currentUser?.uid }) {
//                users.remove(at: i)
//            }
            completion(users)
        }
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
        
    }
    
    static func fetchConversations(completion: @escaping([Conversation]?, Error?) -> Void) {
        var conversations = [Conversation]()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil, FBError.FIRAuthError)
            return}

        let query = COLLECION_MESSAGES.document(uid).collection(K.recentMessage).order(by: K.timestamp, descending: true)
        query.addSnapshotListener { snapshot, error in
            if let err = error {
                print("DEBUG: 대화 불러오기 실패 \(err.localizedDescription)")
                completion(nil, err)
                return
            }
            if snapshot?.documents.count == 0 {
                completion(nil, error)
                print("DEBUG: 대화 불러오기 실패1 ")
                return
            }
           
            snapshot?.documentChanges.forEach({ change in
                print("DEBUG: 대화 불러오기 실패2 ")
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUid: message.toID) { user in
                    print("DEBUG: 대화 불러오기 실패3 ")
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations, nil)
                }
                
            })
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping(([Message]) -> Void) ) {
        var message = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECION_MESSAGES.document(currentUid).collection(user.uid).order(by: K.timestamp)
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    message.append(Message(dictionary: dictionary))
                    print("스냅샷 추척: \(Message(dictionary: dictionary).text)")
                }
            })
            completion(message)
        }
        
//        query.addSnapshotListener { snapshot, error in
//            guard let change = snapshot?.documentChanges.last, change.type == .added else {return}
//            let dictionary = change.document.data()
//            completion(Message(dictionary: dictionary))
//        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data = [K.text: message,
                    K.fromID: currentUid,
                    K.toID: user.uid,
                    K.timestamp: Timestamp(date: Date())] as [String: Any] as [String: Any]
        
        if currentUid != user.uid {
            COLLECION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
                COLLECION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
                COLLECION_MESSAGES.document(currentUid).collection(K.recentMessage).document(user.uid).setData(data, completion: completion)
                COLLECION_MESSAGES.document(user.uid).collection(K.recentMessage).document(currentUid).setData(data)
            }
        } else {
            COLLECION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) {_ in
                COLLECION_MESSAGES.document(currentUid).collection(K.recentMessage).document(user.uid).setData(data, completion: completion)
            }
            
        }
    }
}
