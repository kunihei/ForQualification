//
//  ForQualificationTests.swift
//  ForQualificationTests
//
//  Created by 祥平 on 2021/09/05.
//

import XCTest
@testable import ForQualification

class ForQualificationTests: XCTestCase {
    let settingProblem = SettingProblem()

    let problemCount = 50
    let answerCpunt = 60
    let selctEmptyCount = 8
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let problemAnswerEmptyValue = self.settingProblem.problemAnswerEmptyValue(problemstatementCount: problemCount, answerCount: answerCpunt)
        let selectEmptyValue = self.settingProblem.selectEmptyValue(emptyCount: selctEmptyCount)
        XCTAssertEqual(problemAnswerEmptyValue, false)
        XCTAssertEqual(selectEmptyValue, false)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
