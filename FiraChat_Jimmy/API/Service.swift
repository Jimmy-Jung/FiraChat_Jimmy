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
        COLLECION_USERS.getDocuments { snapshot, error in
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
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
        
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
    
        guard let uid = Auth.auth().currentUser?.uid else {
            return}
        let query = COLLECION_MESSAGES.document(uid).collection(K.recentMessage).order(by: K.timestamp)
        
        query.addSnapshotListener { snapshot, error in
            if let err = error {
                print("DEBUG: 대화 불러오기 실패 \(err.localizedDescription)")
            }
            snapshot?.documentChanges.forEach({ change in
          
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUid: message.toID) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    print("대화 메세지 \(conversation.message.text)")
                    completion(conversations)
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
                    K.fromID: user.uid,
                    K.timestamp: Timestamp(date: Date())] as [String: Any] as [String: Any]
        
        COLLECION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) {_ in 
            COLLECION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            //최근 대화 만들기
            COLLECION_MESSAGES.document(currentUid).collection(K.recentMessage).document(user.uid).setData(data)
            
            COLLECION_MESSAGES.document(user.uid).collection(K.recentMessage).document(currentUid).setData(data)
        }
    }
}
