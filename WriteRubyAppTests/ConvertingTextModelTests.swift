//
//  ConvertedTextModelTests.swift
//  WriteRubyAppTests
//
//  Created by 田内　翔太郎 on 2020/02/03.
//  Copyright © 2020 田内　翔太郎. All rights reserved.
//

import XCTest
@testable import WriteRubyApp

class ConvertedTextModelTests: XCTestCase {

    let model = ConvertingTextModel()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateRequest() {
        let testSentence = "漢字漢字"
        XCTAssertNotNil(model.createRequest(sentence: testSentence))
    }

    func testMakeHTTPBody() {

        let testSentence = "漢字漢字"
        XCTAssertNotNil(model.makeHTTPBody(sentence: testSentence))

        let testOutputType = "katakana"
        XCTAssertNotNil(model.makeHTTPBody(sentence: testSentence, outputType: testOutputType))


    }
}
