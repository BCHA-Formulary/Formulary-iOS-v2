//
//  DrugClass+CoreDataProperties.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-04.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import CoreData


extension DrugClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrugClass> {
        return NSFetchRequest<DrugClass>(entityName: "DrugClass")
    }

    @NSManaged public var drugClass: String?
    @NSManaged public var drugEntry: NSSet?

}

// MARK: Generated accessors for drugEntry
extension DrugClass {

    @objc(addDrugEntryObject:)
    @NSManaged public func addToDrugEntry(_ value: DrugEntry)

    @objc(removeDrugEntryObject:)
    @NSManaged public func removeFromDrugEntry(_ value: DrugEntry)

    @objc(addDrugEntry:)
    @NSManaged public func addToDrugEntry(_ values: NSSet)

    @objc(removeDrugEntry:)
    @NSManaged public func removeFromDrugEntry(_ values: NSSet)

}
