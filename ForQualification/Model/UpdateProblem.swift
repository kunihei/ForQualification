//
//  UpdateProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/10/09.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UpdateProblem {
    var editProblemstatement = String()
    var editProblemImageData = Data()
    var answer               = String()
    var selectList           = [String]()
    var documentId           = String()
    var userId               = String()
    var createAt             = Double()
    
    init(editProblemstatement: String,  answer: String, select1: String, select2: String, select3: String, select4: String, select5: String, select6: String, select7: String, select8: String, select9: String, select10: String, documentId: String, userId: String, createAt: Double) {
        self.editProblemstatement = editProblemstatement
        self.answer               = answer
        self.documentId           = documentId
        self.userId               = userId
        self.createAt             = createAt
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
    
    init (editProblemstatement: String, problemImageData: Data, answer: String, select1: String, select2: String, select3: String, select4: String, select5: String, select6: String, select7: String, select8: String, select9: String, select10: String, documentId: String, userId: String, createAt: Double) {
        self.editProblemstatement = editProblemstatement
        self.editProblemImageData = problemImageData
        self.answer               = answer
        self.documentId           = documentId
        self.userId               = userId
        self.createAt             = createAt
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
    
    func isImageUpdateProblem() -> Bool {
        if !self.editProblemImageData.isEmpty {
            let desertRef = Storage.storage().reference().child("problemImages").child("\(userId + String(createAt)).jpg")
            desertRef.delete { err in
                if let err = err {
                    print("画像の削除に失敗しました。", err)
                    return
                }
            }
            let editProblemImageRef = Storage.storage().reference().child("problemImages").child("\(userId + String(createAt)).jpg")
            editProblemImageRef.putData(editProblemImageData, metadata: nil) { metaData, err in
                if let err = err {
                    print("画像のアップロードに失敗しました", err)
                    return
                }
                editProblemImageRef.downloadURL { url, err in
                    if let err = err {
                        print("画像の取得に失敗しました", err)
                        return
                    }
                    
                    Firestore.firestore().collection("problems").document(self.documentId).updateData([
                        "problem"     : self.editProblemstatement,
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
                        "updateAt"    : Date().timeIntervalSince1970
                    ]) { err in
                        if let err = err {
                            print("更新に失敗しました", err)
                            return
                        }
                    }
                }
            }
        }
        return true
    }
    
    func noImageupdateProblem() -> Bool {
        Firestore.firestore().collection("problems").document(self.documentId).updateData([
            "problem"     : self.editProblemstatement,
            "problemImage": "",
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
            "updateAt"    : Date().timeIntervalSince1970
        ]) { err in
            if let err = err {
                print("更新に失敗しました", err)
                return
            }
        }
        return true
    }
}
