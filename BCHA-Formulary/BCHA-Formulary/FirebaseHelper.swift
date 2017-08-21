//
//  FirebaseHelper.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-04-26.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseHelper {
    var ref: FIRDatabaseReference
    
    init() {
        //Set firebase for retrieve data
        ref = FIRDatabase.database().reference()
    }
    
    func updateAllEntries(lastUpdated:String, completionHandler: @escaping ([DrugBase], String)->Void) {
        var firebaseLastUpdate:String = "none"
            ref.child("Update").observeSingleEvent(of: .value, with: {(snapshot) in
                firebaseLastUpdate = (snapshot.value as! NSString) as String
                if(firebaseLastUpdate != lastUpdated) {
                    self.getFirebaseDrugList(firebaseUpdateDate: firebaseLastUpdate, updateCompleteHandler: completionHandler)
                }
                else {
                    //all up to date!
                    completionHandler([], "")
                }
            }) { (error) in
                print(error.localizedDescription)
            }
    }
    
    func getFirebaseDrugList(firebaseUpdateDate:String, updateCompleteHandler: @escaping ([DrugBase], String) -> Void) {
        var firebaseUpdatedCount = 0 //things that have been sucessfully parsed
        var allDrugList = [DrugBase]()

        getFormularyDrugList(completionHandler: {formularyDrugList in
            allDrugList.append(contentsOf:formularyDrugList)
            firebaseUpdatedCount += 1
            if (firebaseUpdatedCount >= 3) {
                updateCompleteHandler(allDrugList, firebaseUpdateDate)
            }
        })
        
        getExcludedDrugList(completionHandler: {excludedDrugList in
            allDrugList.append(contentsOf:excludedDrugList)
            firebaseUpdatedCount += 1
            if (firebaseUpdatedCount >= 3) {
                updateCompleteHandler(allDrugList, firebaseUpdateDate)
            }
        })
        getRestrictedDrugList(completionHandler: {restrictedDrugList in
            allDrugList.append(contentsOf:restrictedDrugList)
            firebaseUpdatedCount += 1
            if (firebaseUpdatedCount >= 3) {
                updateCompleteHandler(allDrugList, firebaseUpdateDate)
            }
        })
    }
    
    func getFormularyDrugList(completionHandler: @escaping ([DrugBase]) -> Void) {
        ref.child("Formulary").observe(.value, with: { snapshot in
            var formularyCount = 0
            var formularyDrugs = [DrugBase]()
            for drugObj in snapshot.children {
                let drugProp = (drugObj as! FIRDataSnapshot).value as! NSDictionary
                
                let pName = drugProp["primaryName"] as! String
                
                let nTypeString = drugProp["nameType"] as! String
                let nType:NameType
                if (nTypeString == NameType.GENERIC.rawValue) {
                    nType = NameType.GENERIC
                } else {
                    nType = NameType.BRAND
                }
                
                //TODO find a better way to typecheck
                var drugClass:[String]
                if let drugClassArr = drugProp["drugClass"] as? NSMutableArray {
                    drugClass = self.trimNSNull(arr: drugClassArr)
                } else {
                    let drugClassDict = drugProp["drugClass"] as! NSDictionary
                    drugClass = self.trimNSNull(arr: drugClassDict.allValues as! NSMutableArray)
                }
                
                var altNames:[String]
                if let altNamesArr = drugProp["alternateName"] as? NSMutableArray {
                    altNames = self.trimNSNull(arr: altNamesArr)
                } else {
                    let altNamesDict = drugProp["alternateName"] as! NSDictionary
                    altNames = self.trimNSNull(arr: altNamesDict.allValues as! NSMutableArray)
                }
                
                var strengths:[String]
                if let strengthDict = drugProp["strengths"] as? NSDictionary {
                        print(strengthDict)
                    strengths = self.trimNSNull(arr: strengthDict.allValues as! NSMutableArray)
                } else {
                    let strengthArr = drugProp["strengths"] as! NSMutableArray
                    strengths = self.trimNSNull(arr: strengthArr)
                }
                
                let fDrug = FormularyDrug.init(primaryName: pName, nameType: nType, alternateNames: altNames, status: Status.FORMULARY, drugClass: drugClass, strengths: strengths)
                
                formularyDrugs.append(fDrug)
                formularyCount += 1
            }
            //done loading all objects
            print("Formulary drug count:" + String(formularyCount))
            completionHandler(formularyDrugs)
        })
    }
    
    func getExcludedDrugList(completionHandler: @escaping ([DrugBase]) -> Void) {
        ref.child("Excluded").observe(.value, with: { snapshot in
            var excludedCount = 0
            var excludedDrugs = [DrugBase]()
            for drugObj in snapshot.children {
                let drugProp = (drugObj as! FIRDataSnapshot).value as! NSDictionary
                
                let pName = drugProp["primaryName"] as! String
                
                let nTypeString = drugProp["nameType"] as! String
                let nType:NameType
                if (nTypeString == NameType.GENERIC.rawValue) {
                    nType = NameType.GENERIC
                } else {
                    nType = NameType.BRAND
                }
                
                let crit = drugProp["criteria"] as! String
                
                let drugClassArr = drugProp["drugClass"] as! NSMutableArray
                let drugClass = self.trimNSNull(arr: drugClassArr)
                
                let altNamesArr = drugProp["alternateName"] as! NSMutableArray
                let altNames = self.trimNSNull(arr: altNamesArr)
                
                let eDrug = ExcludedDrug.init(primaryName: pName, nameType: nType, alternateNames: altNames, criteria: crit, status: Status.EXCLUDED, drugClass: drugClass)
                
                excludedDrugs.append(eDrug) //TODO testing - remove later
                excludedCount += 1
            }
            //done loading all objects
            print("Excluded drug count:" + String(excludedCount))
            completionHandler(excludedDrugs)
        })
    }
    
    func getRestrictedDrugList(completionHandler: @escaping ([DrugBase]) -> Void) {
        ref.child("Restricted").observe(.value, with: { snapshot in
            var restrictedCount = 0
            var restrictedDrugs = [DrugBase]()
            for drugObj in snapshot.children {
                let drugProp = (drugObj as! FIRDataSnapshot).value as! NSDictionary
                
                let pName = drugProp["primaryName"] as! String
                
                let nTypeString = drugProp["nameType"] as! String
                let nType:NameType
                if (nTypeString == NameType.GENERIC.rawValue) {
                    nType = NameType.GENERIC
                } else {
                    nType = NameType.BRAND
                }
                
                let crit = drugProp["criteria"] as! String
                
                let drugClassArr = drugProp["drugClass"] as! NSMutableArray
                let drugClass = self.trimNSNull(arr: drugClassArr)
                
                let altNamesArr = drugProp["alternateName"] as! NSMutableArray
                let altNames = self.trimNSNull(arr: altNamesArr)
                
                let rDrug = RestrictedDrug.init(primaryName: pName, nameType: nType, alternateNames: altNames, criteria: crit, status: Status.RESTRICTED, drugClass: drugClass)
                
                restrictedDrugs.append(rDrug)
                restrictedCount += 1
            }
            //done loading all objects
            print("Restricted drug count:" + String(restrictedCount))
            completionHandler(restrictedDrugs)
        })
        
    }
    
    /*
     * Firebase Endpoint: "Update"
     * Gets the timestamp of the last time the database was updated.
     * If error or does not exist, return ""
     */
    func getLastUpdate(callback:(_ snapshot:FIRDataSnapshot)-> Void) -> String {
        var update:String = ""
        ref.child("Update").observeSingleEvent(of: .value, with: { (snapshot) in
            update = snapshot.value as! String
        }) { (error) in
            print(error.localizedDescription)
        }
        return update
    }
    
    /*
     *   Due to the nature of adding/deleting firebase array elements, the indexing of some lists
     *   may include some elements in the NSArray which are NSNull, these are elements we do NOT
     *   want to include in our objects and tables so are filtered out before creating them
     */
    //TODO move this function to a better place
    private func trimNSNull(arr:NSMutableArray) -> [String] {
        var stringArr = [String]()
        for element in arr {
            if let e  = element as? String {
                stringArr.append(e)
            }
        }
        return stringArr
    }
    
}
