//
//  ProblemRegistSingleton.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/23.
//

import Foundation

final class ProblemSelect {
    static let shared = ProblemSelect()
    private var selects = [Int: String]()
    private var problemText = String()
    private var imageData: Data? = Data()
    private init() {}
    
    func setProblemText(text: String) {
        problemText = text
    }
    
    func setImageData(image: Data?) {
        imageData = image
    }
    
    func setSelects(array: [Int: String]) {
        selects = array
    }
    
    func getProblemText() -> String { return problemText }
    func getImageData() -> Data { return imageData ?? Data() }
    func getSelects() -> [Int: String] { return selects }
}
