//
//  RestrictedDrug.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2016-07-11.
//  Copyright © 2016 BCHA. All rights reserved.
//

import Foundation

class RestrictedDrug: DrugBase {
    var criteria:String
    
    init(primaryName:String, nameType:NameType, alternateNames:[String], criteria:String, status:Status, drugClass:[String]){
        self.criteria = criteria
        super.init(primaryName: primaryName, nameType: nameType, alternateNames: alternateNames, drugClass: drugClass, status: status)
    }
}
