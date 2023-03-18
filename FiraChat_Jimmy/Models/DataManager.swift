//
//  DataManager.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/17.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    static var loginCheck = false
    //private var chatBoxArray: [ChatBox] = []
    private init() {
        print("메모리 할당")
        
    }
    
//    func getChetData() -> [ChatBox] {
//        return chatBoxArray
//    }
//
//    func updateData(sender: String, message: String, date: TimeInterval) {
//        let chatBox = ChatBox(sender: sender, message: message, date: date)
//        chatBoxArray.append(chatBox)
//    }
//
//    func getLastData() -> ChatBox {
//        return chatBoxArray[chatBoxArray.endIndex - 1]
//    }
//
    
    
    deinit {
        print("메모리 해제")
    }
}
