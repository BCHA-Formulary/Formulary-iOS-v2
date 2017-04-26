//
//  FormularyDrug.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2016-07-11.
//  Copyright © 2016 BCHA. All rights reserved.
//

import Foundation

class FormularyDrug:DrugBase{
    var strengths = [String]()
    
    init(primaryName:String, nameType:NameType, alternateNames:[String], status:Status, drugClass:[String], strengths:[String]){
        self.strengths = strengths
        super.init(primaryName: primaryName, nameType: nameType, alternateNames: alternateNames, drugClass: drugClass, status: status)
    }
}
