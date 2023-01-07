//
//  ChallengeProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2022/08/15.
//

import Foundation

class ChallengeProblemModel {
    private init() {}
    static let shard = ChallengeProblemModel()
    
    var problemSelectEmptyDelete = [String]()
    var shuffleModeFlag = false
    var problemCount = 0
}
