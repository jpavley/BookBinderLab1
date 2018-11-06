//
//  ComicBookCollectible.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/6/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

struct ComicBookCollectible {
    
    let publisher: JsonModel.JsonPublisher
    let series: JsonModel.JsonPublisher.JsonSeries
    let volume: JsonModel.JsonPublisher.JsonSeries.JsonVolume
    let work: JsonModel.JsonPublisher.JsonSeries.JsonVolume.JsonWork
    let variant: JsonModel.JsonPublisher.JsonSeries.JsonVolume.JsonWork.JsonVariant
    
}
