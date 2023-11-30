//
//  MessageList.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/11.
//

import Foundation

struct MessageList {
    struct Photo {
        static let select = "どちらを使用しますか？"
    }
    
    struct Empty {
        static let title = "未入力"
        static let emptyProblem = "問題文は必須項目です"
        static let emptyAnswer  = "回答文は必須項目です"
        static let emptySelect  = "選択肢は必須項目です"
    }
}
