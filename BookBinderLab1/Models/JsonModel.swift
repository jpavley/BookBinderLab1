//
//  JsonModel.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/3/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// Models a BookBinder Series with Works and Variants in JSON.
/// Sample JOSN code:
/// ```
/// {
///      "selectedURI": "",
///      "series":
///      [
///          {
///              "seriesPublisher": "",
///              "seriesTitle": "",
///              "seriesEra": 0,
///              "seriesVolume": 1,
///              "seriesFirstWork": 0,
///              "seriesCurrentWork": 0,
///              "seriesSkippedWorks": [
///                 0
///             ],
///              "works":
///              [
///                  {
///                      "workNumber": 0,
///                      "variants":
///                      [
///                          {
///                              "printing": 0,
///                              "letter": "",
///                              "coverImageID": "",
///                              "isOwned": true
///                          }
///                      ]
///                  }
///              ]
///          }
///      ]
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



