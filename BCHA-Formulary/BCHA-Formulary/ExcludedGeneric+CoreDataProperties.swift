//
//  ExcludedGeneric+CoreDataProperties.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-04.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import CoreData


extension ExcludedGeneric {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExcludedGeneric> {
        return NSFetchRequest<ExcludedGeneric>(entityName: "ExcludedGeneric")
    }

    @NSManaged public var brandName: [NSString]?
    @NSManaged public var criteria: String?
    @NSManaged public var genericName: String?

}
