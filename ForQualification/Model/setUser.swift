//
//  setUser.swift
//  ForQualification
//
//  Created by 祥平 on 2022/10/09.
//

import Foundation
import FirebaseAuth

class User {
    private init() {}
    static let shard = User()
    
    var userID = Auth.auth().currentUser?.uid
}
