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
}
