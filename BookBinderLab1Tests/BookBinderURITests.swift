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
        let uriUT1 = BookBinderURI()
        XCTAssertNotNil(uriUT1)
    }
    
    func testInitFromProperties() {
        let uriUT1 = BookBinderURI(versionPart: "1", publisherPart: "publisher", titlePart: "title", eraPart: "era",
                                   volumePart: "volume", issuePart: "issue", printingPart: "printing", variantPart: "variant")
        XCTAssertNotNil(uriUT1)

        XCTAssertEqual(BookBinderURI.part(fromURIString: uriUT1.description, partID: .version), "1")
        XCTAssertEqual(BookBinderURI.part(fromURIString: uriUT1.description, partID: .publisher), "publisher")
        XCTAssertEqual(BookBinderURI.part(fromURIString: uriUT1.description, partID: .title), "title")
        XCTAssertEqual(BookBinderURI.part(fromURIString: uriUT1.description, partID: .era), "era")
        XCTAssertEqual(BookBinderURI.part(fromURIString: uriUT1.description, partID: .volume), "volume")
        XCTAssertEqual(BookBinderURI.part(fromURIString: uriUT1.description, partID: .issue), "issue")
        XCTAssertEqual(BookBinderURI.part(fromURIString: uriUT1.description, partID: .printing), "printing")

    }
    
    func testInitFromString() {
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
    
    func testSeriesURI() {
        let uriUT1 = BookBinderURI(fromURIString: testURIString1)
        let seriesURI1 = uriUT1?.seriesURI
        XCTAssertEqual(seriesURI1?.description, testSeriesURIString)
        
        let uriUT2 = BookBinderURI(fromURIString: badURI)
        let seriesURI2 = uriUT2?.seriesURI
        XCTAssertNil(seriesURI2)
        
        let uriUT3 = BookBinderURI(fromURIString: emptyURI)
        let seriesURI3 = uriUT3?.seriesURI
        XCTAssertEqual(seriesURI3?.description, emptyURI)
    }
    
    func testWorkURI() {
        let uriUT1 = BookBinderURI(fromURIString: testURIString1)
        let workURI1 = uriUT1?.workURI
        XCTAssertEqual(workURI1?.description, testWorkURIString)
        
        let uriUT2 = BookBinderURI(fromURIString: badURI)
        let workURI2 = uriUT2?.workURI
        XCTAssertNil(workURI2)
        
        let uriUT3 = BookBinderURI(fromURIString: emptyURI)
        let workURI3 = uriUT3?.workURI
        XCTAssertEqual(workURI3?.description, emptyURI)
    }
    
    func testVariantURI() {
        let uriUT1 = BookBinderURI(fromURIString: testURIString1)
        let workURI1 = uriUT1?.variantURI
        XCTAssertEqual(workURI1?.description, testVariantURIString)
        
        let uriUT2 = BookBinderURI(fromURIString: badURI)
        let workURI2 = uriUT2?.variantURI
        XCTAssertNil(workURI2)
        
        let uriUT3 = BookBinderURI(fromURIString: emptyURI)
        let workURI3 = uriUT3?.variantURI
        XCTAssertEqual(workURI3?.description, emptyURI)
    }
    
    func testHashable() {
        let uriUT1 = BookBinderURI(fromURIString: testURIString1)
        let uriUT2 = BookBinderURI(fromURIString: "1/publisher1/title/era/volume/issue/printing/variant")
        let uriUT3 = BookBinderURI(fromURIString: testURIString1)
        
        XCTAssertTrue(uriUT1 == uriUT3)
        XCTAssertFalse(uriUT1 == uriUT2)
        
        var dictionary1: [BookBinderURI:String] = [:]
        dictionary1[uriUT1!] = "one"
        dictionary1[uriUT2!] = "two"
        
        XCTAssertEqual(dictionary1[uriUT1!], "one")
        XCTAssertEqual(dictionary1[uriUT2!], "two")
    }


}
