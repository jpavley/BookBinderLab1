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
    
    func testURI() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        let selectedURI = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        let selectedComicbook = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        
        XCTAssertEqual(selectedComicbook.uri, selectedURI)
    }
    
    func testIsOwned() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        
        let selectedURI = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        let selectedComicbook = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook.isOwned, true)
        
        let anotherURI = BookBinderURI(from: "1/Marble Entertainment/Eternal Bells/1970/1/")
        let anotherComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(anotherComicBook.isOwned, false)
    }
    
    func testWasRead() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        
        let selectedURI = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        let selectedComicbook = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook.wasRead, true)

        let anotherURI = BookBinderURI(from: "1/Marble Entertainment/Eternal Bells/1970/2/")
        let anotherComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(anotherComicBook.wasRead, false)
    }
    
    func testPurchase() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        let selectedURI = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        
        let selectedComicbook = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook.isOwned, true)
        comicBookCollection.purchase(uri: selectedURI!)
        let selectedComicbook2 = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook2.isOwned, true)
        
        let anotherURI = BookBinderURI(from: "1/Marble Entertainment/Eternal Bells/1970/1/")
        let prepurchaseComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(prepurchaseComicBook.isOwned, false)
        comicBookCollection.purchase(uri: anotherURI!)
        let postpurchaseComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(postpurchaseComicBook.isOwned, true)
    }
    
    func testUnpurchase() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        let selectedURI = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        
        let selectedComicbook = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook.isOwned, true)
        comicBookCollection.unpurchase(uri: selectedURI!)
        let selectedComicbook2 = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook2.isOwned, false)
        
        let anotherURI = BookBinderURI(from: "1/Marble Entertainment/Eternal Bells/1970/2/")
        let prepurchaseComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(prepurchaseComicBook.isOwned, true)
        comicBookCollection.unpurchase(uri: anotherURI!)
        let postpurchaseComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(postpurchaseComicBook.isOwned, false)
    }
    
    func testBuyAndSell() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        
        for (_, value) in comicBookCollection.comicBookDictionary {
            comicBookCollection.purchase(uri: value)
        }
        
        for (_, value) in comicBookCollection.comicBookDictionary {
            let comicBook = comicBookCollection.comicBookCollectibleBy(uri: value)
            XCTAssertEqual(comicBook.isOwned, true)
        }
        
        for (_, value) in comicBookCollection.comicBookDictionary {
            comicBookCollection.unpurchase(uri: value)
        }
        
        for (_, value) in comicBookCollection.comicBookDictionary {
            let comicBook = comicBookCollection.comicBookCollectibleBy(uri: value)
            XCTAssertEqual(comicBook.isOwned, false)
        }
    }
    
    func testRead() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        let selectedURI = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        
        let selectedComicbook = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook.wasRead, true)
        let selectedComicbook2 = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        comicBookCollection.read(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook2.wasRead, true)
        
        let anotherURI = BookBinderURI(from: "1/Marble Entertainment/Eternal Bells/1970/2/")
        let prepurchaseComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(prepurchaseComicBook.wasRead, false)
        comicBookCollection.read(uri: anotherURI!)
        let postpurchaseComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(postpurchaseComicBook.wasRead, true)
    }
    
    func testUnread() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        let selectedURI = BookBinderURI(from: comicBookCollection.comicBookModel.selectedURI)
        
        let selectedComicbook = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook.wasRead, true)
        comicBookCollection.unread(uri: selectedURI!)
        let selectedComicbook2 = comicBookCollection.comicBookCollectibleBy(uri: selectedURI!)
        XCTAssertEqual(selectedComicbook2.wasRead, false)
        
        let anotherURI = BookBinderURI(from: "1/Marble Entertainment/Eternal Bells/1970/1/")
        let prepurchaseComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(prepurchaseComicBook.wasRead, true)
        comicBookCollection.unread(uri: anotherURI!)
        let postpurchaseComicBook = comicBookCollection.comicBookCollectibleBy(uri: anotherURI!)
        XCTAssertEqual(postpurchaseComicBook.wasRead, false)
    }
    
    func testReadAndForget() {
        let comicBookCollection = ComicBookCollection(comicBookModel: jsonModel)
        
        for (_, value) in comicBookCollection.comicBookDictionary {
            comicBookCollection.read(uri: value)
        }
        
        for (_, value) in comicBookCollection.comicBookDictionary {
            let comicBook = comicBookCollection.comicBookCollectibleBy(uri: value)
            XCTAssertEqual(comicBook.wasRead, true)
        }
        
        for (_, value) in comicBookCollection.comicBookDictionary {
            comicBookCollection.unread(uri: value)
        }
        
        for (_, value) in comicBookCollection.comicBookDictionary {
            let comicBook = comicBookCollection.comicBookCollectibleBy(uri: value)
            XCTAssertEqual(comicBook.wasRead, false)
        }
    }


}
