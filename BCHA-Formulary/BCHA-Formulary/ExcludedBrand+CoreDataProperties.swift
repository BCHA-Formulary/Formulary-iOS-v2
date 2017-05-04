//
//  ExcludedBrand+CoreDataProperties.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-04.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import CoreData


extension ExcludedBrand {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExcludedBrand> {
        return NSFetchRequest<ExcludedBrand>(entityName: "ExcludedBrand")
    }

    @NSManaged public var brandName: String?
    @NSManaged public var criteria: String?
    @NSManaged public var genericName: NSObject?

}
