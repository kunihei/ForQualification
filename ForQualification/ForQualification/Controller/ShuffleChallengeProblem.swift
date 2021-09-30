//
//  ShuffleChallengeProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/30.
//

import UIKit

class ShuffleChallengeProblem {
    var getSelectList = GetProblemSelect()
    
    func initSelect() {
        getSelectList.getProblemSelect()
    }
    
    func getSelect(problemCount: Int) -> [String] {
        getSelectList.selectEmptyDelete(problemCount: problemCount)
        return getSelectList.problemSelectEmptyDelete
    }

}
