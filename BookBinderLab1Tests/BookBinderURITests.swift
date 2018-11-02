//
//  BookBinderURITests.swift
//  BookBinderLab1Tests
//
//  Created by John Pavley on 11/1/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class BookBinderURITests: XCTestCase {
    
    let emptyString = ""
    let badURI   = "///////"
    let emptyURI = "1///////"
    let testURIString1 = "1/publisher/title/era/volume/issue/printing/variant"
    let testSeriesURIString = "1/publisher/title/era/volume///"
    let testWorkURIString = "1/publisher/title/era/volume/issue//"
    let testVariantURIString = "1/publisher/title/era/volume/issue/printing/variant"


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit() {
        let uriUT1 = BookBinderURI(fromURIString: emptyString)
        XCTAssertNil(uriUT1)
        
        let uriUT2 = BookBinderURI(fromURIString: badURI)
        XCTAssertNil(uriUT2)
        
        let uriUT3 = BookBinderURI(fromURIString: emptyURI)
        XCTAssertNotNil(uriUT3)
        XCTAssertEqual(uriUT3?.description, emptyURI)
        
        let uriUT4 = BookBinderURI(fromURIString: testURIString1)
        XCTAssertNotNil(uriUT4)
        XCTAssertEqual(uriUT4?.description, testURIString1)
    }
    
    func testPartFromURIString() {
        
        XCTAssertEqual(BookBinderURI.part(fromURIString: testURIString1, partID: .version), "1")
        XCTAssertEqual(BookBinderURI.part(fromURIString: testURIString1, partID: .publisher), "publisher")
        XCTAssertEqual(BookBinderURI.part(fromURIString: testURIString1, partID: .title), "title")
        XCTAssertEqual(BookBinderURI.part(fromURIString: testURIString1, partID: .era), "era")
        XCTAssertEqual(BookBinderURI.part(fromURIString: testURIString1, partID: .volume), "volume")
        XCTAssertEqual(BookBinderURI.part(fromURIString: testURIString1, partID: .issue), "issue")
        XCTAssertEqual(BookBinderURI.part(fromURIString: testURIString1, partID: .printing), "printing")
        XCTAssertEqual(BookBinderURI.part(fromURIString: testURIString1, partID: .variant), "variant")
        
        XCTAssertEqual(BookBinderURI.part(fromURIString: emptyURI, partID: .version), "1")
        XCTAssertEqual(BookBinderURI.part(fromURIString: emptyURI, partID: .publisher), "")
        XCTAssertEqual(BookBinderURI.part(fromURIString: emptyURI, partID: .title), "")
        XCTAssertEqual(BookBinderURI.part(fromURIString: emptyURI, partID: .era), "")
        XCTAssertEqual(BookBinderURI.part(fromURIString: emptyURI, partID: .volume), "")
        XCTAssertEqual(BookBinderURI.part(fromURIString: emptyURI, partID: .issue), "")
        XCTAssertEqual(BookBinderURI.part(fromURIString: emptyURI, partID: .printing), "")
        XCTAssertEqual(BookBinderURI.part(fromURIString: emptyURI, partID: .variant), "")

        XCTAssertEqual(BookBinderURI.part(fromURIString: badURI, partID: .version), nil)
        XCTAssertEqual(BookBinderURI.part(fromURIString: badURI, partID: .publisher), nil)
        XCTAssertEqual(BookBinderURI.part(fromURIString: badURI, partID: .title), nil)
        XCTAssertEqual(BookBinderURI.part(fromURIString: badURI, partID: .era), nil)
        XCTAssertEqual(BookBinderURI.part(fromURIString: badURI, partID: .volume), nil)
        XCTAssertEqual(BookBinderURI.part(fromURIString: badURI, partID: .issue), nil)
        XCTAssertEqual(BookBinderURI.part(fromURIString: badURI, partID: .printing), nil)
        XCTAssertEqual(BookBinderURI.part(fromURIString: badURI, partID: .variant), nil)
    }
    
    func testExtractSeriesURIString() {
        XCTAssertEqual(BookBinderURI.extractSeriesURIString(fromURIString: testURIString1), testSeriesURIString)
        XCTAssertEqual(BookBinderURI.extractSeriesURIString(fromURIString: emptyURI), emptyURI)
        XCTAssertEqual(BookBinderURI.extractSeriesURIString(fromURIString: badURI), nil)
    }
    
    func testExtractWorkURIString() {
        XCTAssertEqual(BookBinderURI.extractWorkURIString(fromURIString: testURIString1), testWorkURIString)
        XCTAssertEqual(BookBinderURI.extractWorkURIString(fromURIString: emptyURI), emptyURI)
        XCTAssertEqual(BookBinderURI.extractWorkURIString(fromURIString: badURI), nil)
    }
    
    func testExtractVariantURIString() {
        XCTAssertEqual(BookBinderURI.extractVariantURIString(fromURIString: testURIString1), testVariantURIString)
        XCTAssertEqual(BookBinderURI.extractVariantURIString(fromURIString: emptyURI), emptyURI)
        XCTAssertEqual(BookBinderURI.extractVariantURIString(fromURIString: badURI), nil)
    }

}
