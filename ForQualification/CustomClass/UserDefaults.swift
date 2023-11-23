//
//  UserDefaults.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/11.
//

import UIKit

struct UserDefault {
    static let userDefault = UserDefaults.standard
    struct Key {
        struct Problem {
            static let imageData    = "imageData"
            static let problemText  = "problemText"
            static let selects      = "selects"
        }
    }
}


extension UserDefault {
    struct Problem {
//        static var selects: Data? {
//            get {
//                return userDefault.data(forKey: Key.Problem.selects)
//            }
//            
//            set {
//                userDefault.setValue(newValue, forKey: Key.Problem.selects)
//            }
//        }
        static var selects: [Int: String]? {
            get {
                return userDefault.value(forKey: Key.Problem.selects) as! [Int: String]
            }
            
            set {
                userDefault.set(newValue, forKey: Key.Problem.selects)
            }
        }
        static var imageData: Data? {
            get {
                return userDefault.data(forKey: Key.Problem.imageData)
            }
            
            set {
                userDefault.setValue(newValue, forKey: Key.Problem.imageData)
            }
        }
        static var problemText: String? {
            get {
                return userDefault.string(forKey: Key.Problem.problemText)
            }
            
            set {
                userDefault.setValue(newValue, forKey: Key.Problem.problemText)
            }
        }
    }
}
