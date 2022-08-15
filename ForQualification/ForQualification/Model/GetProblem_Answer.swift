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
    static var problemList:[Problem_AnswerModel] = []
    var currentUserId = String()
    
    func getProblemList() {
        currentUserId = Auth.auth().currentUser?.uid ?? ""
        GetProblem_Answer.problemList = []
        Firestore.firestore().collection("problems").order(by: "updateAt").addSnapshotListener { snapshot, err in
            if let err = err {
                print("問題と解答の取得に失敗しました。", err)
                return
            }
            
            if let snapshotDoc = snapshot?.documents {
                for doc in snapshotDoc {
                    let data = doc.data()
                    let documentID = doc.documentID
                    if self.currentUserId == data["userId"] as? String {
                        if let problem = data["problem"] as? String, let problemImageData = data["problemImage"] as? String, let answer = data["answer"] as? String, let createAt = data["createAt"] as? Double, let documentID = documentID as? String {
                            GetProblem_Answer.problemList.append(Problem_AnswerModel(problem: problem, problemImageData: problemImageData, answer: answer, createAt: createAt, documentID: documentID))
                            
                        } else if let problem = data["problem"] as? String, let answer = data["answer"] as? String, let createAt = data["createAt"] as? Double, let documentID = documentID as? String {
                            GetProblem_Answer.problemList.append(Problem_AnswerModel(problem: problem, problemImageData: "", answer: answer, createAt: createAt, documentID: documentID))
                        }
                    }
                }
                GetProblem_Answer.problemList.reverse()
            }
        }
    }
}
