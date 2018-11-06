//
//  ComicBookCollectionTests.swift
//  BookBinderLab1Tests
//
//  Created by John Pavley on 11/5/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import XCTest

class ComicBookCollectionTests: XCTestCase {
    
    var jsonModel: JsonModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        if let path = Bundle.main.path(forResource: "sample1", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                do {
                    let decoder = JSONDecoder()
                    jsonModel = try decoder.decode(JsonModel.self, from: data)
                    // succeeding -> data loaded and decoded
                } catch {
                    // failing -> can't decode!
                    print(error)
                }
                
            } catch {
                // failing -> can't load data!
                print(error)
            }
        }

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        XCTAssertNotNil(comicBookCollection)
        let indexPath1 = IndexPath(item: 0, section: 0)
        XCTAssertEqual(comicBookCollection.comicBookDictionary[indexPath1]?.description, "1/Marble Entertainment/The People Under The Chair/1950/1/")
    }
}
