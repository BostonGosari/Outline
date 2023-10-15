//
//  FireStoreManager.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI


struct UserModel {
    let database = Firestore.firestore()
    // TODO: ResultType으로 VM에서 completion으로 핸들링하는게 제일 예쁠 것 같다.
    func writeUserData(user: User) {
        let userListRef = database.collection("userList").document(user.uid)
        userListRef.updateData([
            "uid": user.uid,
            "nickname": user.nickname,
            "height": user.height,
            "weight": user.weight,
            "gender": user.gender.rawValue,
            "imageURL": "",
            "records": [],
            "currentRunningData": []
        ]) { error in
            guard let error = error else {
                return
            }
            print("error")
        }
    }
//        userListRef.getDocuments { (snapshot, error) in
//            guard error == nil else {
//                print("error", error ?? "")
//                return
//            }
//            guard let snapshot = snapshot else {return}
//            
//            for document in snapshot.documents {
//                let data = document.data()
//            
//                let name = data["nickname"] as? String ?? ""
//                let heightTemp = data["height"] as? Int ?? 0
//                self.userList.append(User(nickname: name, height: heightTemp))
//            }
//        }
    
    
    
//    @Published var userList: [User] = []
//    @Published var nickName: String = ""
//    @Published var height: Int = 0
//    let db = Firestore.firestore()
//    
//    init() {
////        fetchData()
//        fetchUserListData()
//    }
//    func fetchUserListData(){
//        let userListRef = db.collection("userList")
//        
//        userListRef.getDocuments { (snapshot, error) in
//            guard error == nil else {
//                print("error", error ?? "")
//                return
//            }
//            guard let snapshot = snapshot else {return}
//            
//            for document in snapshot.documents {
//                let data = document.data()
//            
//                let name = data["nickname"] as? String ?? ""
//                let heightTemp = data["height"] as? Int ?? 0
//                self.userList.append(User(nickname: name, height: heightTemp))
//            }
//                        
//        }
//    }
//
//    func fetchData() {
//        print("fetch data")
//        let userRef = db.collection("userList").document("4JACo00t3iuK8dfyDiFx")
//        userRef.getDocument { (document, error) in
//            guard error == nil else {
//                print("error", error ?? "")
//                return
//            }
//            
//            if let document = document, document.exists {
//                let data = document.data()
//                if let data = data {
//                    self.nickName = data["nickname"] as? String ?? ""
//                    self.height = data["height"] as? Int ?? 0
//                }
//            }
//        }
//    }
}
