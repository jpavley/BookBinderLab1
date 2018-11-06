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
}
