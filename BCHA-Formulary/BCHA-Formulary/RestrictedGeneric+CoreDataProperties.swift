//
//  RestrictedGeneric+CoreDataProperties.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-04.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import CoreData


extension RestrictedGeneric {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestrictedGeneric> {
        return NSFetchRequest<RestrictedGeneric>(entityName: "RestrictedGeneric")
    }

    @NSManaged public var brandName: [NSString]?
    @NSManaged public var criteria: String?
    @NSManaged public var genericName: String?

}
