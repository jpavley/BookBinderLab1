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
    
    func getIndexOfVariantBy(uri: BookBinderURI, work: JsonModel.JsonPublisher.JsonSeries.JsonVolume.JsonWork) -> Int {
        var result = -1
        for i in 0..<work.variants.count {
            if work.variants[i].letter == uri.variantPart {
                result = i
                break
            }
        }
        return result
    }

    func getIndexOfWorkBy(uri: BookBinderURI, volume: JsonModel.JsonPublisher.JsonSeries.JsonVolume) -> Int {
        var result = -1
        for i in 0..<volume.works.count {
            if volume.works[i].number == Int(uri.issuePart) {
                result = i
                break
            }
        }
        return result
    }

    func getIndexOfVolumeBy(uri: BookBinderURI, series: JsonModel.JsonPublisher.JsonSeries) -> Int {
        var result = -1
        for i in 0..<series.volumes.count {
            if series.volumes[i].era == Int(uri.volumePart) {
                result = i
                break
            }
        }
        return result
    }
    
    func getIndexOfSeriesBy(uri: BookBinderURI, publisher: JsonModel.JsonPublisher) -> Int {
        var result = -1
        for i in 0..<publisher.series.count {
            if publisher.series[i].title == uri.seriesPart {
                result = i
                break
            }
        }
        return result
    }
    
    func getIndexOfPublisherBy(uri: BookBinderURI) -> Int {
        var result = -1
        for i in 0..<comicBookModel.publishers.count {
            if comicBookModel.publishers[i].name == uri.publisherPart {
                result = i
                break
            }
        }
        return result
    }
    
    func setDateCollected(uri: BookBinderURI, setting: String) {
        let pi = getIndexOfPublisherBy(uri: uri)
        let si = getIndexOfSeriesBy(uri: uri, publisher: comicBookModel.publishers[pi])
        let vi = getIndexOfVolumeBy(uri: uri, series: comicBookModel.publishers[pi].series[si])
        let wi = getIndexOfWorkBy(uri: uri, volume: comicBookModel.publishers[pi].series[si].volumes[vi])
        let vi2 = getIndexOfVariantBy(uri: uri, work: comicBookModel.publishers[pi].series[si].volumes[vi].works[wi])
        
        comicBookModel.publishers[pi].series[si].volumes[vi].works[wi].variants[vi2].dateCollected = setting
    }
    
    /**
     Updates dateCollect on a collectible with the curernt date.
     - Parameters:
         - uir: The uri of the collectible to purchase
    */
    func purchase(uri: BookBinderURI) {
        
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let dateCollected = df.string(from: Date())
        setDateCollected(uri: uri, setting: dateCollected)
    }
    
    func unpurchase(uri: BookBinderURI) {
        setDateCollected(uri: uri, setting: "")
    }
}
