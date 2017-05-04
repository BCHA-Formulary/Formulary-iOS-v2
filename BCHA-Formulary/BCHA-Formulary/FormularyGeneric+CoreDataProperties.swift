//
//  FormularyGeneric+CoreDataProperties.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-04.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import CoreData


extension FormularyGeneric {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormularyGeneric> {
        return NSFetchRequest<FormularyGeneric>(entityName: "FormularyGeneric")
    }

    @NSManaged public var brandName: NSObject?
    @NSManaged public var genericName: String?
    @NSManaged public var strength: NSObject?

}
