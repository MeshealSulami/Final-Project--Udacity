//
//  Photo+CD.swift
//  Virtual Tourist
//
//  Created by Shan'ana Fire on 08/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData


extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    @NSManaged public var imageData: NSData?
    @NSManaged public var urlString: String?
    @NSManaged public var pin: Pin?
    
}

