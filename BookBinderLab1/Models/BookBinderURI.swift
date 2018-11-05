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

/// MVP 3: Simple URI format with versioning and less parts.
/// - version/publisher/series/volume/issue/variant
/// - Int/String/String/Int/Int/String
/// - 0/1/2/3/4/5
/// - All valid URIs begin with a version number and contain a the correct number of slashes for that version.
/// - Missing parts are ok.
/// - Example: Version 1 URIs start the Integer 1 and contain five slashes.
/// - Full URI: "1/Marvel Entertainment/DoctorStrange/2018/1/c".
/// - Empty URI: "1/////".
struct BookBinderURI {
    
    // MARK:- URI validation properties
    
    static let currentVersion = 1
    static let slashCount = 5
    static let emptyURIString = "1/////"
    
    /// String that represents a URI version prefix like "1".
    var versionPart: String
    
    /// String that represents a publisher like "Ziff Davis".
    var publisherPart: String
    
    /// String that represents the title of a series like "ROM Spaceknight".
    var seriesPart: String
    
    /// String that represents an volume number like "1".
    var volumePart: String
    
    /// String that represents an issue number like "608"
    var issuePart: String
    
    /// String that represents a variant letter like "c"
    var variantPart: String
    
    // MARK:- Initialization
    
    init() {
        versionPart = ""
        publisherPart = ""
        seriesPart = ""
        volumePart = ""
        issuePart = ""
        variantPart = ""
    }
    
    init(versionPart: String, publisherPart: String, seriesPart: String, volumePart: String, issuePart: String, variantPart: String) {
        
        self.versionPart = versionPart
        self.publisherPart = publisherPart
        self.seriesPart = seriesPart
        self.volumePart = volumePart
        self.issuePart = issuePart
        self.variantPart = variantPart
    }
    
    /// Initialize a URI from a well formed URI string
    init?(fromURIString s: String) {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            print("** BAD URI \(s)")
            return nil
        }
        
        versionPart = BookBinderURI.part(fromURIString: s, partID: .version) ?? ""
        publisherPart = BookBinderURI.part(fromURIString: s, partID: .publisher) ?? ""
        seriesPart = BookBinderURI.part(fromURIString: s, partID: .series) ?? ""
        volumePart = BookBinderURI.part(fromURIString: s, partID: .volume) ?? ""
        issuePart = BookBinderURI.part(fromURIString: s, partID: .issue) ?? ""
        variantPart = BookBinderURI.part(fromURIString: s, partID: .variant) ?? ""
    }
    
    // MARK:- Methods
    
    /// Returns the specified part of an URI
    ///
    static func part(fromURIString s: String, partID: URIPart) -> String? {
        
        if !BookBinderURI.isWellFormed(uriString: s) {
            return nil
        }
        
        let parts = s.components(separatedBy: "/")
        
        if parts.count > partID.rawValue {
            let part = parts[partID.rawValue]
            return part.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return ""
    }
    
    // MARK:- Validation
    
    /// Returns returns true if a URI contains the correct number of "/"s and start with the correct version number
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
        result += makePart(part: seriesPart)
        result += makePart(part: volumePart)
        result += makePart(part: issuePart)
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

