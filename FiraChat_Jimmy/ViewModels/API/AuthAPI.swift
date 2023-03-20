//
//  AuthService.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/20.
//

import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct AuthAPI {
    
    static func logInUser(withEmail email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        //파이어베이스 로그인
        Auth.auth().signIn(withEmail: email, password: password) {
            authResult, error in
           
            if let error = error as NSError? {
                    // 로그인 실패
                    print(error.localizedDescription)
                    var message = ""
                switch error.code {
                case AuthErrorCode.networkError.rawValue:
                    message = "인터넷 연결을 확인해주세요."
                case AuthErrorCode.userNotFound.rawValue:
                    message = "등록되지 않은 이메일 입니다."
                case AuthErrorCode.wrongPassword.rawValue:
                    message = "비밀번호가 올바르지 않습니다."
                default:
                    message = "로그인에 실패했습니다."
                    }
                completion(false, message)
              
            } else {
                completion(true, nil)
            }
        }
    }
    
    static func createUser(withEmail email: String, password: String, name: String, imageData: Data, completion: @escaping (Error?) -> Void) {
            // 서버에 프로필 저장하기
            let filename = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
            ref.putData(imageData, metadata: nil) { (meta, error) in
                if let error = error {
                    print("DEBUG: Failed to upload image with error\(error.localizedDescription)")
                    completion(error)
                    return
                }
                // 스토리지에 저장된 사진 Url 가져오기
                ref.downloadURL { (url, error) in
                    guard let profileImageUrl = url?.absoluteString else { return }

                    // 계정 만들기
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if let error = error {
                            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
                           completion(error)
                            return
                        }

                        guard let uid = result?.user.uid else { return }

                        let data = ["name": name,
                                    "email": email,
                                    "profileImageUrl": profileImageUrl,
                                    "uid": uid] as [String: Any]

                        Firestore.firestore().collection("users").document(uid).setData(data) { err in
                            if let err = err {
                                print("Error adding document: \(err.localizedDescription)")
                                completion(err)
                            } else {
                                print("Document added with ID: \(uid)")
                                completion(nil)
                            }
                        }
                    }
                }
            }
        }
    
    
    private init() {}
}
