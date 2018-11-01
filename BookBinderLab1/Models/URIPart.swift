//
//  URIPart.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/1/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// Parts of a URI mapped to postion in a URI string.
/// version/publisher/title/era/volume/issue/printing/variant
/// 0/1/2/3/4/5/6/7
enum URIPart: Int {
    
    // version
    case version = 0
    
    // series parts
    case publisher = 1
    case title = 2
    case era = 3
    case volume = 4
    
    // work parts
    case issue = 5
    
    // variant parts
    case printing = 6
    case variant = 7
}
