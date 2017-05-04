//
//  FormularyBrand+CoreDataProperties.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-04.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import CoreData


extension FormularyBrand {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormularyBrand> {
        return NSFetchRequest<FormularyBrand>(entityName: "FormularyBrand")
    }

    @NSManaged public var brandName: String?
    @NSManaged public var genericName: NSObject?
    @NSManaged public var strength: NSObject?

}
