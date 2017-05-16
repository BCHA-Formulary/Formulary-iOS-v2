//
//  DrugEntry+CoreDataProperties.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-16.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import CoreData


extension DrugEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrugEntry> {
        return NSFetchRequest<DrugEntry>(entityName: "DrugEntry")
    }

    @NSManaged public var name: String?
    @NSManaged public var nameType: String?
    @NSManaged public var status: String?
    @NSManaged public var drugClass: DrugClass?

}
