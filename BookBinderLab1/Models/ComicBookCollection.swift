//
//  ComicBookCollection.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/5/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

class ComicBookCollection {
    
    var comicBookModel: JsonModel
    var comicBookDictionary: [IndexPath: BookBinderURI]
    
    init(comicBookModel: JsonModel) {
        self.comicBookModel = comicBookModel
        self.comicBookDictionary = ComicBookCollection.createComicBookDictionary(comicBookModel: comicBookModel)
    }
    
    static func createComicBookDictionary(comicBookModel: JsonModel) -> [IndexPath: BookBinderURI] {
        var comicBookDictionary = [IndexPath: BookBinderURI]()
        
        var section: Int
        var item: Int
        
        section = 0
        for publisher in comicBookModel.publishers {
            for series in publisher.series {
                item = 0
                for volume in series.volumes {
                    for work in volume.works {
                        for variant in work.variants {
                            
                            let key = IndexPath(item: item, section: section)
                            let value = BookBinderURI(versionPart: "1", publisherPart: publisher.name, seriesPart: series.title, volumePart: String(volume.era), issuePart: String(work.number), variantPart: variant.letter)
                            
                            comicBookDictionary[key] = value
                            // print("key sec:\(key.section), itm: \(key.item), value \(value.seriesPart) \(value.volumePart)  #\(value.issuePart)\(value.variantPart)")
                            item += 1
                        }
                    }
                }
                section += 1
            }
        }
        
        return comicBookDictionary
    }
    
    func comicBookCollectibleBy(uri: BookBinderURI) -> ComicBookCollectible {
        
        let publisher =  comicBookModel.publishers.filter {$0.name == uri.publisherPart}.first!
        let series = publisher.series.filter {$0.title == uri.seriesPart}.first!
        let volume = series.volumes.filter {$0.era == Int(uri.volumePart)!}.first!
        let work = volume.works.filter {$0.number == Int(uri.issuePart)!}.first!
        let variant = work.variants.filter {$0.letter == uri.variantPart}.first!
        
        return ComicBookCollectible(publisher: publisher, series: series, volume: volume, work: work, variant: variant)
    }
    
    /**
     Posts a transation on a collectable to the collection. If collected is true then the current
     date is used to as the date collected. If consummed is true than the current date is used as
     date consummed. Otherwise the current values of date collected and consummed are passed along.
     - Parameters:
         - uir: The uri of the collectible to change
         - collected: If true the collectibile has been collected (purchased, rented)
         - consumed: if true the collectible has been consumeed (read, watched)
     - Note: Passing false for both collected and consumed does not result in a change.
    */
    func transact(uri: BookBinderURI, collected: Bool, consummed: Bool) {
        
        if !collected && !consummed {
            // nothing has changed
            return
        }
        
        let publisher =  comicBookModel.publishers.filter {$0.name == uri.publisherPart}.first!
        let series = publisher.series.filter {$0.title == uri.seriesPart}.first!
        let volume = series.volumes.filter {$0.era == Int(uri.volumePart)!}.first!
        var work = volume.works.filter {$0.number == Int(uri.issuePart)!}.first!
        let variant = work.variants.filter {$0.letter == uri.variantPart}.first!
        
        var dateCollected = variant.dateCollected
        if collected {
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            dateCollected = df.string(from: Date())
        }
        
        var dateConsumed = variant.dateConsumed
        if consummed {
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            dateConsumed = df.string(from: Date())
        }
        
        let purchasedVarient = JsonModel.JsonPublisher.JsonSeries.JsonVolume.JsonWork.JsonVariant(datePublished: variant.datePublished, kind: variant.kind, printing: variant.printing, letter: variant.letter, coverID: variant.coverID, dateCollected: dateCollected, DateConsumed: dateConsumed)
        
        for i in 0...work.variants.count {
            if work.variants[i].letter == purchasedVarient.letter {
                work.variants.remove(at: i)
                work.variants.insert(purchasedVarient, at: i)
            }
        }
    }
}
