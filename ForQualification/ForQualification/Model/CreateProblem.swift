//
//  CreateProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/25.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class CreateProblem {
    var problemstatement = String()
    var problemImageData = Data()
    var userId = String()
    
    init (problemstatement: String, userId: String) {
        self.problemstatement = problemstatement
        self.userId = userId
    }
    
    init (problemstatement: String, problemImageData: Data, userId: String) {
        self.problemstatement = problemstatement
        self.problemImageData = problemImageData
        self.userId = userId
    }
    
    func isImageCreateProblem() {
        if !self.problemImageData.isEmpty {
            let problemImageRef = Storage.storage().reference().child("problemImages").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
            problemImageRef.putData(problemImageData, metadata: nil) { metaData, err in
                if let err = err {
                    print("画像の保存に失敗しました。", err)
                    return
                }
                problemImageRef.downloadURL { url, err in
                    if let err = err {
                        print("画像の取得に失敗しました", err)
                        return
                    }
                    Firestore.firestore().collection("problems").addDocument(data: [
                        "problem": self.problemstatement,
                        "problemImage": url?.absoluteString,
                        "userId": self.userId,
                        "createAt": Date().timeIntervalSince1970
                    ]) {(err) in
                        
                        if err != nil {
                            print(err.debugDescription)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func noImageCreateProblem() {
        Firestore.firestore().collection("problems").addDocument(data: [
            "problem": self.problemstatement,
            "userId": self.userId,
            "createAt": Date().timeIntervalSince1970
        ]) {(err) in
            
            if err != nil {
                print(err.debugDescription)
                return
            }
        }
    }
}
