//
//  RestrictedBrand+CoreDataProperties.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-04.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import CoreData


extension RestrictedBrand {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestrictedBrand> {
        return NSFetchRequest<RestrictedBrand>(entityName: "RestrictedBrand")
    }

    @NSManaged public var brandName: String?
    @NSManaged public var criteria: String?
    @NSManaged public var genericName: [NSString]?

}
