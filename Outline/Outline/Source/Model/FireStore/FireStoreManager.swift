//
//  FireStoreManager.swift
//  Outline
//
//  Created by Seungui Moon on 10/14/23.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class FireStoreManager: ObservableObject {
    @Published var nickName: String = ""
    @Published var height: Int = 0
    let db = Firestore.firestore()
    
    init() {
       fetchData()
    }

    func fetchData() {
        print("fetch data")
        let docRef = db.collection("userList").document("4JACo00t3iuK8dfyDiFx")
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.nickName = data["nickname"] as? String ?? ""
                    self.height = data["height"] as? Int ?? 0
                }
            }
        }
    }
}
