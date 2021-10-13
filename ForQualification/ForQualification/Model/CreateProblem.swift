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
    var selectList:[String] = []
    var userId           = String()
    
    init (problemstatement: String, answer: String, select1: String, select2: String, select3: String, select4: String, select5: String, select6: String, select7: String, select8: String, select9: String, select10: String, userId: String) {
        self.problemstatement = problemstatement
        self.answer           = answer
        self.userId           = userId
        self.selectList.append(select1)
        self.selectList.append(select2)
        self.selectList.append(select3)
        self.selectList.append(select4)
        self.selectList.append(select5)
        self.selectList.append(select6)
        self.selectList.append(select7)
        self.selectList.append(select8)
        self.selectList.append(select9)
        self.selectList.append(select10)
    }
    
    init (problemstatement: String, problemImageData: Data, answer: String, select1: String, select2: String, select3: String, select4: String, select5: String, select6: String, select7: String, select8: String, select9: String, select10: String, userId: String) {
        self.problemstatement = problemstatement
        self.problemImageData = problemImageData
        self.answer           = answer
        self.userId           = userId
        self.selectList.append(select1)
        self.selectList.append(select2)
        self.selectList.append(select3)
        self.selectList.append(select4)
        self.selectList.append(select5)
        self.selectList.append(select6)
        self.selectList.append(select7)
        self.selectList.append(select8)
        self.selectList.append(select9)
        self.selectList.append(select10)
    }
    
    func isImageCreateProblem() -> Bool {
        if !self.problemImageData.isEmpty {
            let problemImageRef = Storage.storage().reference().child("problemImages").child("\(userId + problemstatement).jpg")
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
                        "select1"     : self.selectList[0],
                        "select2"     : self.selectList[1],
                        "select3"     : self.selectList[2],
                        "select4"     : self.selectList[3],
                        "select5"     : self.selectList[4],
                        "select6"     : self.selectList[5],
                        "select7"     : self.selectList[6],
                        "select8"     : self.selectList[7],
                        "select9"     : self.selectList[8],
                        "select10"    : self.selectList[9],
                        "userId"      : self.userId,
                        "createAt"    : Date().timeIntervalSince1970
                    ]) {(err) in
                        
                        if err != nil {
                            print("登録に失敗しました。", err)
                            return
                        }
                    }
                }
            }
        }
        return true
    }
    
    
    func noImageCreateProblem() -> Bool {
        Firestore.firestore().collection("problems").addDocument(data: [
            "problem"     : self.problemstatement,
            "answer"      : self.answer,
            "select1"     : self.selectList[0],
            "select2"     : self.selectList[1],
            "select3"     : self.selectList[2],
            "select4"     : self.selectList[3],
            "select5"     : self.selectList[4],
            "select6"     : self.selectList[5],
            "select7"     : self.selectList[6],
            "select8"     : self.selectList[7],
            "select9"     : self.selectList[8],
            "select10"    : self.selectList[9],
            "userId"      : self.userId,
            "createAt"    : Date().timeIntervalSince1970
        ]) {(err) in
            
            if err != nil {
                print("登録に失敗しました。", err)
                return
            }
        }
        return true
    }
}
