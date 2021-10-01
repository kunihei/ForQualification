//
//  GetProblem_Answer.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/27.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class GetProblem_Answer {
    var problemList:[Problem_AnswerModel] = []
    var currentUserId = Auth.auth().currentUser?.uid
    
    func getProblemList() {
        Firestore.firestore().collection("problems").order(by: "createAt").addSnapshotListener { snapshot, err in
            if let err = err {
                print("問題と解答の取得に失敗しました。", err)
                return
            }
            
            if let snapshotDoc = snapshot?.documents {
                for doc in snapshotDoc {
                    let data = doc.data()
                    let documentID = doc.documentID
                    print(documentID)
                    print("kuni")
                    if self.currentUserId == data["userId"] as? String {
                        if let problem = data["problem"] as? String, let problemImageData = data["problemImage"] as? String, let answer = data["answer"] as? String, let documentID = documentID as? String {
                            self.problemList.append(Problem_AnswerModel(problem: problem, problemImageData: problemImageData, answer: answer, documentID: documentID))
                            
                        } else if let problem = data["problem"] as? String, let answer = data["answer"] as? String, let documentID = documentID as? String {
                            self.problemList.append(Problem_AnswerModel(problem: problem, problemImageData: "", answer: answer, documentID: documentID))
                        }
                    }
                }
                self.problemList.reverse()
            }
        }
    }
}
