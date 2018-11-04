//
//  JsonModel.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/3/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// Models a BookBinder Series with Works and Variants in JSON.
/// - `Publisher` has a name and contains a list of series.
/// - `Series` has a title, a list of characters, and a list of volumes.
/// - `Volume` has a kind (publishing frequency), era (year), number, set of properties used to
///   calculate uncollected works (firstWorkNumber, currentWorkNumber, list of skippedWorkNumbers),
///   and a list of works.
/// - `Work` has a number and a list of variants.
/// - `Variant` has a date published, kind (publishing media), printing, letter, coverID,
///   dateCollected, and dateConsumed (consumption properties used to determin ownership and
///   tracking.
/// - *Note: each work has a URI, which are used as keys to identify works in a dictionary but
///   URIs are calucated at runtime so not serialized in JSON except for the selectedURI which
///   lets an app know what the user was looking at the time of serialization.*
/// ```
/// {
///     "selectedURI": "version-number/publisher-name/series-title/volume-era/work-number/variant-letter",
///     "publisher": [
///         {
///             "name": "",
///             "series": [
///                 {
///                     "title": "",
///                     "characters": [
///                         {
///                             "name": ""
///                         }
///                     ],
///                     "volumes": [
///                         {
///                             "kind": "ongoing, miniseries, one-shot, annual",
///                             "era": 0,
///                             "number": 0,
///                             "firstWorkNumber": 0,
///                             "currentWorkNumber": 0,
///                             "skippedWorkNumbers": [
///                                 {
///                                     "number": 0
///                                 }
///                             ],
///                             "works": [
///                                 {
///                                     "number": 0,
///                                     "variants": [
///                                         {
///                                             "datePublished": "",
///                                             "kind": "magazine, trade, digital",
///                                             "printing": 0,
///                                             "letter": "",
///                                             "coverID": "",
///                                             "dateColleted": "",
///                                             "dateConsumed": ""
///                                         }
///                                     ]
///                                 }
///                             ]
///                         }
///                     ]
///                 }
///             ]
///         }
///     ]
/// }
/// ```
struct JsonModel: Codable {
    
    // TODO: What about tags?
    
    struct JsonSeries: Codable {
        let seriesPublisher: String
        let seriesTitle: String
        let seriesEra: Int
        let seriesVolume: Int
        let seriesFirstWork: Int
        let seriesCurrentWork: Int
        let seriesSkippedWorks: [Int]
        let works: [JsonWork]
        
        struct JsonWork: Codable {
            let workNumber: Int
            let variants: [JsonVariant]
            
            struct JsonVariant: Codable {
                let printing: Int
                let letter: String
                let isOwned: Bool
                let coverImageID: String
                
                init(printing: Int, letter: String, isOwned: Bool, coverImageID: String) {
                    self.printing = printing
                    self.letter = letter
                    self.isOwned = isOwned
                    self.coverImageID = coverImageID
                }
            }
            
            init(workNumber: Int, variants: [JsonVariant]) {
                self.workNumber = workNumber
                self.variants = variants
            }
        }
        
        init(publisher: String, title: String, era: Int, volumeNumber: Int, firstWork: Int, currentWork: Int, skippedWorks: [Int], works: [JsonWork]) {
            
            self.seriesPublisher = publisher
            self.seriesTitle = title
            self.seriesEra = era
            self.seriesVolume = volumeNumber
            self.seriesFirstWork = firstWork
            self.seriesCurrentWork = currentWork
            self.seriesSkippedWorks = skippedWorks
            self.works = works
        }
    }
    
    let series: [JsonSeries]
    let selectedURI: String
    
    init(series: [JsonSeries], selectedURI: String) {
        
        self.series = series
        self.selectedURI = selectedURI
    }
}



