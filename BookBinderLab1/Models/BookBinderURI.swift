//
//  BookBinderURI.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/1/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

//
//  BookBinderURI.swift
//  Book Binder
//
//  Created by John Pavley on 9/23/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

/// MVP 2: Simple URI format with versioning.
/// version/publisher/title/era/volume/issue/printing/variant
/// Int/String/String/Int/Int/Int/Int/String
/// - All valid URIs begin with a version number and contain a the correct number of slashes for that version.
/// - Missing parts are ok.
/// - Example: Version 1 URIs start the Integer 1 and seven slashes.
/// - Full URI: "1/Marvel Entertainment/DoctorStrange/2018/1/2/1/c".
/// - Series URI: "1/Marvel Entertainment/DoctorStrange/2018/1///".
/// - Work URI: "1////1//".
/// - Variant URI: "1//////1/c"
/// - Empty URI: "1///////".
struct BookBinderURI {
    
    // MARK:- URI validation properties
    
    static let currentVersion = 1
    static let slashCount = 7
    static let emptyURIString = "1///////"
    
    // MARK:-  Series Properties
    
    /// String that represents a URI version prefix like "1".
    var versionPart: String
    
    /// String that represents a publisher like "Ziff Davis".
    var publisherPart: String
    
    /// String that represents the title of a series like "ROM Spaceknight".
    var titlePart: String
    
    /// String that represents an era date like "1950".
    var eraPart: String
    
    /// String that represents an volume number like "1".
    var volumePart: String
    
    // MARK:- Work Properties
    
    /// String that represents an issue number like "608"
    var issuePart: String
    
    // MARK:- Variant Properties
    
    /// String that represents a printing designation like "1".
    var printingPart: String
    
    
    /// String that represents a variant letter like "c"
    var variantPart: String
    
    // MARK:- Initialization
    
    /// Initialize a URI from a well formed URI string
    ///
    /// version/publisher/title/era/volume/issue/printing/variant
    /// 0/1/2/3/4/5/6/7
    init?(fromURIString s: String) {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            print("** BAD URI \(s)")
            return nil
        }
        
        versionPart = BookBinderURI.part(fromURIString: s, partID: .version)
        publisherPart = BookBinderURI.part(fromURIString: s, partID: .publisher)
        titlePart = BookBinderURI.part(fromURIString: s, partID: .title)
        eraPart = BookBinderURI.part(fromURIString: s, partID: .era)
        volumePart = BookBinderURI.part(fromURIString: s, partID: .volume)
        issuePart = BookBinderURI.part(fromURIString: s, partID: .issue)
        printingPart = BookBinderURI.part(fromURIString: s, partID: .printing)
        variantPart = BookBinderURI.part(fromURIString: s, partID: .variant)
    }
    
    // MARK:- Methods
    
    /// Returns the specified part of an URI
    ///
    /// - Part Names: publisher/title/era/volume/printing/issue/variant
    /// - Parts Index: 0/1/2/3/4/5/6
    static func part(fromURIString s: String, partID: URIPart) -> String {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return BookBinderURI.emptyURIString
        }
        
        let parts = s.components(separatedBy: "/")
        
        if parts.count > partID.rawValue {
            let part = parts[partID.rawValue]
            return part.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return ""
        }
    }
    
    /// Returns just the series parts of an URI
    ///
    /// version/publisher/title/era/volume///
    /// 0/1/2/3/4///
    static func extractSeriesURIString(fromURIString s: String) -> String {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return BookBinderURI.emptyURIString
        }
        
        let parts = s.components(separatedBy: "/")
        
        let publisherPart = parts.count >= URIPart.publisher.rawValue + 1 ? parts[URIPart.publisher.rawValue] : ""
        let titlePart = parts.count >= URIPart.title.rawValue + 1 ? parts[URIPart.title.rawValue] : ""
        let eraPart = parts.count >= URIPart.era.rawValue + 1 ? parts[URIPart.era.rawValue] : ""
        let volumePart = parts.count >= URIPart.volume.rawValue + 1 ? parts[URIPart.volume.rawValue] : ""
        
        return "\(publisherPart)/\(titlePart)/\(eraPart)/\(volumePart)///"
    }
    
    /// Returns the series and work parts of an URI
    ///
    /// version/publisher/title/era/volume/issue//
    /// 0/1/2/3/4/5//
    static func extractWorkURIString(fromURIString s: String) -> String {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return BookBinderURI.emptyURIString
        }
        
        let parts = s.components(separatedBy: "/")
        
        let publisherPart = parts.count >= URIPart.publisher.rawValue + 1 ? parts[URIPart.publisher.rawValue] : ""
        let titlePart = parts.count >= URIPart.title.rawValue + 1 ? parts[URIPart.title.rawValue] : ""
        let eraPart = parts.count >= URIPart.era.rawValue + 1 ? parts[URIPart.era.rawValue] : ""
        let volumePart = parts.count >= URIPart.volume.rawValue + 1 ? parts[URIPart.volume.rawValue] : ""
        let issuePart = parts.count >= URIPart.issue.rawValue + 1 ? parts[URIPart.issue.rawValue] : ""
        
        return "\(publisherPart)/\(titlePart)/\(eraPart)/\(volumePart)//\(issuePart)/"
    }
    
    
    var seriesPart: BookBinderURI {
        return BookBinderURI(fromURIString: BookBinderURI.extractSeriesURIString(fromURIString: self.description)) ?? BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
    }
    
    var workPart: BookBinderURI {
        return BookBinderURI(fromURIString: BookBinderURI.extractWorkURIString(fromURIString: self.description)) ?? BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
    }
    
    
    /// Returns returns true if a URI contains the correct number of "/"s and start with the correct version number
    ///
    /// version/publisher/title/era/volume/issue/printing/variant
    /// 0/1/2/3/4/5/6/7
    static func isWellFormed(uriString: String) -> Bool {
        
        var hasCorrectVersionNumber: Bool {
            
            return uriString.starts(with: "1")
        }
        
        var hasCorrectNumberOfSlashes: Bool {
            
            let regex = try? NSRegularExpression(pattern: "/", options: .caseInsensitive)
            let count = regex?.matches(in: uriString, options: [], range: NSRange(location: 0, length: uriString.count)).count
            return count == BookBinderURI.slashCount
        }
        
        return hasCorrectNumberOfSlashes && hasCorrectNumberOfSlashes
    }
}

extension BookBinderURI: CustomStringConvertible {
    
    /// Builds a string version of an URI based on the value of it's parts
    ///
    /// version/publisher/title/era/volume/issue/printing/variant
    /// 0/1/2/3/4/5/6/7
    var description: String {
        
        var result = ""
        
        result += versionPart != "" ? "\(versionPart)" : ""
        result += publisherPart != "" ? "\(publisherPart)" : ""
        result += titlePart != "" ? "/\(titlePart)" : "/"
        result += eraPart != "" ? "/\(eraPart)" : "/"
        result += volumePart != "" ? "/\(volumePart)" : "/"
        result += issuePart != "" ? "/\(issuePart)" : "/"
        result += printingPart != "" ? "/\(printingPart)" : "/"
        result += variantPart != "" ? "/\(variantPart)" : "/"
        
        return result
    }
}

extension BookBinderURI: Hashable {
    
    static func == (lhs: BookBinderURI, rhs: BookBinderURI) -> Bool {
        return lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
    
}

