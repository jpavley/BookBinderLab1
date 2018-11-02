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
/// - version/publisher/title/era/volume/issue/printing/variant
/// - Int/String/String/Int/Int/Int/Int/String
/// - 0/1/2/3/4/5/6/7
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
    /// - version/publisher/title/era/volume/issue/printing/variant
    /// - 0/1/2/3/4/5/6/7
    init?(fromURIString s: String) {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            print("** BAD URI \(s)")
            return nil
        }
        
        versionPart = BookBinderURI.part(fromURIString: s, partID: .version) ?? ""
        publisherPart = BookBinderURI.part(fromURIString: s, partID: .publisher) ?? ""
        titlePart = BookBinderURI.part(fromURIString: s, partID: .title) ?? ""
        eraPart = BookBinderURI.part(fromURIString: s, partID: .era) ?? ""
        volumePart = BookBinderURI.part(fromURIString: s, partID: .volume) ?? ""
        issuePart = BookBinderURI.part(fromURIString: s, partID: .issue) ?? ""
        printingPart = BookBinderURI.part(fromURIString: s, partID: .printing) ?? ""
        variantPart = BookBinderURI.part(fromURIString: s, partID: .variant) ?? ""
    }
    
    // MARK:- Methods
    
    /// Returns the specified part of an URI
    ///
    /// - Part Names: version/publisher/title/era/volume/issue/printing/variant
    /// - Part Indexes: 0/1/2/3/4/5/6/7
    static func part(fromURIString s: String, partID: URIPart) -> String? {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return nil
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
    /// - version/publisher/title/era/volume///
    /// - 0/1/2/3/4///
    static func extractSeriesURIString(fromURIString s: String) -> String? {
        
        if let versionPart = part(fromURIString: s, partID: .version),
            let publisherPart = part(fromURIString: s, partID: .publisher),
            let titlePart = part(fromURIString: s, partID: .title),
            let eraPart = part(fromURIString: s, partID: .era),
            let volumePart = part(fromURIString: s, partID: .volume)
        {
            return "\(versionPart)/\(publisherPart)/\(titlePart)/\(eraPart)/\(volumePart)///"
        } else {
            return nil
        }
    }
    
    /// Returns the series and work parts of an URI
    ///
    /// version/publisher/title/era/volume/issue//
    /// 0/1/2/3/4/5//
    static func extractWorkURIString(fromURIString s: String) -> String? {
        
        if let versionPart = part(fromURIString: s, partID: .version),
            let publisherPart = part(fromURIString: s, partID: .publisher),
            let titlePart = part(fromURIString: s, partID: .title),
            let eraPart = part(fromURIString: s, partID: .era),
            let volumePart = part(fromURIString: s, partID: .volume),
            let issuePart = part(fromURIString: s, partID: .issue)
        {
            return "\(versionPart)/\(publisherPart)/\(titlePart)/\(eraPart)/\(volumePart)/\(issuePart)//"
        } else {
            return nil
        }
    }
    
    /// Returns the series, work, and variant parts of an URI
    ///
    /// version/publisher/title/era/volume/issue/printing/variant
    /// 0/1/2/3/4/5/6/7
    static func extractVariantURIString(fromURIString s: String) -> String? {
        
        if let versionPart = part(fromURIString: s, partID: .version),
            let publisherPart = part(fromURIString: s, partID: .publisher),
            let titlePart = part(fromURIString: s, partID: .title),
            let eraPart = part(fromURIString: s, partID: .era),
            let volumePart = part(fromURIString: s, partID: .volume),
            let issuePart = part(fromURIString: s, partID: .issue),
            let printingPart = part(fromURIString: s, partID: .printing),
            let variantPart = part(fromURIString: s, partID: .variant)
        {
            return "\(versionPart)/\(publisherPart)/\(titlePart)/\(eraPart)/\(volumePart)/\(issuePart)/\(printingPart)/\(variantPart)"
        } else {
            return nil
        }
    }

    
    
    var seriesURI: BookBinderURI {
        if let stringResult = BookBinderURI.extractSeriesURIString(fromURIString: self.description),
            let uriResult = BookBinderURI(fromURIString: stringResult) {
            return uriResult
        } else {
            return BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
        }
    }
    
    var workURI: BookBinderURI {
        if let stringResult = BookBinderURI.extractWorkURIString(fromURIString: self.description),
            let uriResult = BookBinderURI(fromURIString: stringResult) {
            return uriResult
        } else {
            return BookBinderURI(fromURIString: BookBinderURI.emptyURIString)!
        }
    }
    
    /// Returns returns true if a URI contains the correct number of "/"s and start with the correct version number
    ///
    /// version/publisher/title/era/volume/issue/printing/variant
    /// 0/1/2/3/4/5/6/7
    static func isWellFormed(uriString: String) -> Bool {
        
        func hasCorrectVersionNumber(target: Int) -> Bool {
            return uriString.starts(with: "\(target)")
        }
        
        func hasCorrectNumberOfSlashes(target: Int) -> Bool {
            let regex = try? NSRegularExpression(pattern: "/", options: .caseInsensitive)
            let count = regex?.matches(in: uriString, options: [], range: NSRange(location: 0, length: uriString.count)).count
            return count == target
        }
        
        let version = hasCorrectVersionNumber(target: BookBinderURI.currentVersion)
        let slashes = hasCorrectNumberOfSlashes(target: BookBinderURI.slashCount)
        
        return version && slashes
    }
}

extension BookBinderURI: CustomStringConvertible {
    
    /// Builds a string version of an URI based on the value of it's parts
    ///
    /// version/publisher/title/era/volume/issue/printing/variant
    /// 0/1/2/3/4/5/6/7
    var description: String {
        
        func makePart(part: String) -> String {
            return part != "" ? "/\(part)" : "/"
        }
        
        var result = ""
        
        result += makePart(part: versionPart)
        result += makePart(part: publisherPart)
        result += makePart(part: titlePart)
        result += makePart(part: eraPart)
        result += makePart(part: volumePart)
        result += makePart(part: issuePart)
        result += makePart(part: printingPart)
        result += makePart(part: variantPart)
        
        result = String(result.dropFirst())
        
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

