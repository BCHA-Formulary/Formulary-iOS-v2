//
//  DrugBase.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2016-07-11.
//  Copyright © 2016 BCHA. All rights reserved.
//

import Foundation

class DrugBase{
    var primaryName:String
    var nameType:NameType
    var alternateNames = [String]()
    var drugClass = [String]()
    var status:Status
    
    init(primaryName:String, nameType:NameType, alternateNames: [String], drugClass:[String], status:Status){
        self.primaryName = primaryName
        self.nameType = nameType
        self.alternateNames = alternateNames
        self.drugClass = drugClass
        self.status = status
    }
//    
//    init(drugClass:[String], status:Status){
//        self.drugClass = drugClass
//        self.status = status
//    }
}
