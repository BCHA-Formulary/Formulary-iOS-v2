//
//  StringHelper.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-04-27.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation

struct StringHelper {
    static let LAST_UPDATE_KEY = "lastUpdateSaved"
    
    static let DRUG_ENTRY_TABLE = String(describing: DrugEntry.self)
    static let DRUG_CLASS_TABLE = String(describing: DrugClass.self)
    static let FORMUARLY_GENERIC_TABLE = String(describing: FormularyGeneric.self)
    static let FORMUARLY_BRAND_TABLE = String(describing: FormularyBrand.self)
    static let EXCLUDED_GENERIC_TABLE = String(describing: ExcludedGeneric.self)
    static let EXCLUDED_BRAND_TABLE = String(describing: ExcludedBrand.self)
    static let RESTRICTED_GENERIC_TABLE = String(describing: RestrictedGeneric.self)
    static let RESTRICTED_BRAND_TABLE = String(describing: RestrictedBrand.self)
}
