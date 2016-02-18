//
//  Notes.swift
//  Notey
//
//  Created by Antonija Pek on 14/02/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import Foundation

struct PropertyKey {
    static let itemKey = "item"
}

class Notes: NSObject, NSCoding {
    
    // MARK: Properties
    
    var item: String
    var selected: Bool = false

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(item, forKey: PropertyKey.itemKey)
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("item")
        
    required convenience init?(coder aDecoder: NSCoder) {
        let item = aDecoder.decodeObjectForKey(PropertyKey.itemKey) as! String
        
        // Must call designated initializer.
        self.init(item: item)
    }
    
    init?(item: String) {
        // Initialize stored properties.
        self.item = item
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if item.isEmpty {
            return nil
        }
    }
}