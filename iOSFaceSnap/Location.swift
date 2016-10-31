//
//  Location.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 20/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject
{
    static let entityName = "\(Location.self)"
    
    class func locationWith(latitude: Double , longitude: Double) -> Location
    {
        let location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Location
        
        location.latitude = latitude
        location.longitude = longitude
        
        return location 
    }
}

extension Location
{
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
}
