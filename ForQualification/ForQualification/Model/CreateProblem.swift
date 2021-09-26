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
    var answer           = String()
    var select1          = String()
    var select2          = String()
    var select3          = String()
    var select4          = String()
    var select5          = String()
    var select6          = String()
    var select7          = String()
    var select8          = String()
    var select9          = String()
    var select10         = String()
    var userId           = String()
    
    init (problemstatement: String, answer: String, select1: String, select2: String, select3: String, select4: String, select5: String, select6: String, select7: String, select8: String, select9: String, select10: String, userId: String) {
        self.problemstatement = problemstatement
        self.answer           = answer
        self.select1          = select1
        self.select2          = select2
        self.select3          = select3
        self.select4          = select4
        self.select5          = select5
        self.select6          = select6
        self.select7          = select7
        self.select8          = select8
        self.select9          = select9
        self.select10         = select10
        self.userId           = userId
    }
    
    init (problemstatement: String, problemImageData: Data, answer: String, select1: String, select2: String, select3: String, select4: String, select5: String, select6: String, select7: String, select8: String, select9: String, select10: String, userId: String) {
        self.problemstatement = problemstatement
        self.problemImageData = problemImageData
        self.answer           = answer
        self.select1          = select1
        self.select2          = select2
        self.select3          = select3
        self.select4          = select4
        self.select5          = select5
        self.select6          = select6
        self.select7          = select7
        self.select8          = select8
        self.select9          = select9
        self.select10         = select10
        self.userId           = userId
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
                        "problem"     : self.problemstatement,
                        "problemImage": url?.absoluteString,
                        "answer"      : self.answer,
                        "select1"     : self.select1,
                        "select2"     : self.select2,
                        "select3"     : self.select3,
                        "select4"     : self.select4,
                        "select5"     : self.select5,
                        "select6"     : self.select6,
                        "select7"     : self.select7,
                        "select8"     : self.select8,
                        "select9"     : self.select9,
                        "select10"     : self.select10,
                        "userId"      : self.userId,
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
            "answer" : self.answer,
            "select1": self.select1,
            "select2": self.select2,
            "select3": self.select3,
            "select4": self.select4,
            "select5": self.select5,
            "select6": self.select6,
            "select7": self.select7,
            "select8": self.select8,
            "select9": self.select9,
            "select10": self.select10,
            "userId" : self.userId,
            "createAt": Date().timeIntervalSince1970
        ]) {(err) in
            
            if err != nil {
                print(err.debugDescription)
                return
            }
        }
    }
}
