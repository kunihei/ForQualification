//
//  GetProblemSelect.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/26.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class GetProblemSelect {
    var selectList: [ProblemSelectModel] = []
    var currentUserId = Auth.auth().currentUser?.uid
    var problemSelectList = [String]()
    
    func getProblemSelect() {
        Firestore.firestore().collection("problems").order(by: "updateAt").addSnapshotListener { snapshot, err in
            if let err = err {
                print("選択肢の取得に失敗しました。", err)
                return
            }
            
            if let snapshotDoc = snapshot?.documents {
                for doc in snapshotDoc {
                    let data = doc.data()
                    if self.currentUserId == data["userId"] as? String {
                        if let select1 = data["select1"], let select2 = data["select2"], let select3 = data["select3"], let select4 = data["select4"], let select5 = data["select5"], let select6 = data["select6"], let select7 = data["select7"], let select8 = data["select8"], let select9 = data["select9"], let select10 = data["select10"] {
                            self.selectList.append(ProblemSelectModel(select1: select1 as! String, select2: select2 as! String, select3: select3 as! String, select4: select4 as! String, select5: select5 as! String, select6: select6 as! String, select7: select7 as! String, select8: select8 as! String, select9: select9 as! String, select10: select10 as! String))
                        }
                    }
                }
                self.selectList.reverse()
            }
        }
    }
    
    func selectEmptyDelete(problemCount: Int) {
        problemSelectList = []
        ChallengeProblemModel.shard.problemSelectEmptyDelete = []
        for i in 0..<selectList.count {
            if i == problemCount {
                problemSelectList.append(selectList[problemCount].select1)
                problemSelectList.append(selectList[problemCount].select2)
                problemSelectList.append(selectList[problemCount].select3)
                problemSelectList.append(selectList[problemCount].select4)
                problemSelectList.append(selectList[problemCount].select5)
                problemSelectList.append(selectList[problemCount].select6)
                problemSelectList.append(selectList[problemCount].select7)
                problemSelectList.append(selectList[problemCount].select8)
                problemSelectList.append(selectList[problemCount].select9)
                problemSelectList.append(selectList[problemCount].select10)

            }
        }
        // 空の要素の削除
        for i in 0..<problemSelectList.count {
            if problemSelectList[i].isEmpty != true {
                ChallengeProblemModel.shard.problemSelectEmptyDelete.append(problemSelectList[i])
            }
        }
    }
}
