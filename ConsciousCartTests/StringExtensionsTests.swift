//
//  StringExtensionsTests.swift
//  ConsciousCartTests
//
//  Created by Giorgio Latour on 7/22/23.
//

import XCTest
@testable import ConsciousCart

final class StringExtensionsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInvalidStringReturnsFalse() {
        let invalidStrings = ["", "  ", "\n"]
        
        for s in invalidStrings {
            XCTAssertFalse(s.stringInputIsValid(), "\(s) was not determined an invalid string.")
        }
    }
    
    func testValidStringReturnsTrue() {
        let validStrings = ["Test1", " Test2 ", " Test 3\n"]
        
        for s in validStrings {
            XCTAssertTrue(s.stringInputIsValid(), "\(s) was not determined an invalid string.")
        }
    }

}
