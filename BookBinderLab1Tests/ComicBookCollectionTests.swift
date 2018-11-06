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
        
        let indexPath2 = IndexPath(item: 4, section: 1)
        XCTAssertEqual(comicBookCollection.comicBookDictionary[indexPath2]?.description, "1/Marble Entertainment/Eternal Bells/1970/5/c")
        
        XCTAssertEqual(comicBookCollection.comicBookModel.publishers.count, 2)
        XCTAssertEqual(comicBookCollection.comicBookModel.publishers[0].series.count, 2)
        XCTAssertEqual(comicBookCollection.comicBookModel.publishers[0].series[0].volumes.count, 2)
        XCTAssertEqual(comicBookCollection.comicBookModel.publishers[0].series[0].volumes[0].works.count, 2)
        XCTAssertEqual(comicBookCollection.comicBookModel.publishers[0].series[0].volumes[0].works[1].variants.count, 2)
    }
    
    func testComicBookCollectibleByURI() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        let selectedURI = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        let selectedComicbook = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        
        XCTAssertNotNil(selectedComicbook)
        XCTAssertEqual(selectedComicbook.publisher.name, selectedURI?.publisherPart)
        XCTAssertEqual(selectedComicbook.series.title, selectedURI?.seriesPart)
        XCTAssertEqual(selectedComicbook.volume.era, Int((selectedURI?.volumePart)!))
        XCTAssertEqual(selectedComicbook.work.number, Int((selectedURI?.issuePart)!))
        XCTAssertEqual(selectedComicbook.variant.letter, selectedURI?.variantPart)
        
        let anotherURI = BookBinderURI(from: "1/Marble Entertainment/Eternal Bells/1970/5/c")
        let anotherComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertNotNil(anotherComicBook)
        XCTAssertEqual(anotherComicBook.publisher.name, "Marble Entertainment")
        XCTAssertEqual(anotherComicBook.series.title, "Eternal Bells")
        XCTAssertEqual(anotherComicBook.volume.era, 1970)
        XCTAssertEqual(anotherComicBook.work.number, 5)
        XCTAssertEqual(anotherComicBook.variant.letter, "c")

    }
}
