//
//  LaunchViewController.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-04-25.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import CoreData

class LaunchViewController: UIViewController {
//    var ref: FIRDatabaseReference!
//    var drugList = [DrugBase]()
//    var completedCount = 0
    var firebaseHelper: FirebaseHelper!
    var coreDataHelper: CoreDataHelper = CoreDataHelper.coreMain
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let lastUpdate = coreDataHelper.lastUpdated()
        
        firebaseHelper = FirebaseHelper.init()
        firebaseHelper.updateAllEntries(lastUpdated: lastUpdate, completionHandler: { firebaseDrugList in
            if (firebaseDrugList.count == 0) {
                //up to date, no action needed
            } else {
                // update needed
                //TODO drop old entries
                //TODO save new drug list to core data
                print("Number of drugs to update: " + String(firebaseDrugList.count))
            }
            self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
        })
        
//        //Set firebase for retrieve data
//        ref = FIRDatabase.database().reference()
//        //Get Excluded endpoint drug objects
//        ref.child("Excluded").observe(.value, with: { snapshot in
//            var excludedCount = 0
//            var excludedDrugs = [DrugBase]()
//            for drugObj in snapshot.children {
//                let drugProp = (drugObj as! FIRDataSnapshot).value as! NSDictionary
//                
//                let pName = drugProp["primaryName"] as! String
//                
//                let nTypeString = drugProp["nameType"] as! String
//                let nType:NameType
//                if (nTypeString == NameType.GENERIC.rawValue) {
//                    nType = NameType.GENERIC
//                } else {
//                    nType = NameType.BRAND
//                }
//                
//                let crit = drugProp["criteria"] as! String
//                
//                let drugClassArr = drugProp["drugClass"] as! NSMutableArray
//                let drugClass = self.trimNSNull(arr: drugClassArr)
//                
//                let altNamesArr = drugProp["alternateName"] as! NSMutableArray
//                let altNames = self.trimNSNull(arr: altNamesArr)
//                
//                let eDrug = ExcludedDrug.init(primaryName: pName, nameType: nType, alternateNames: altNames, criteria: crit, status: Status.EXCLUDED, drugClass: drugClass)
//                
//                self.drugList.append(eDrug)
//                excludedDrugs.append(eDrug) //TODO testing - remove later
//                excludedCount += 1
//            }
//            //done loading all objects
//            self.completedCount += 1
//            print("Excluded drug count:" + String(excludedCount))
//            //TODO - testing core data
////            self.saveToDrugTable(drugList: excludedDrugs)
////            self.deleteEntries(entityTableName:"DrugTable")
//            self.fetchByAttribute(entityTableName: "DrugTable")
//            //TODO can not put here because of the 3 calls. need to check they are all done before moving on
//            if (self.completedCount == 3){
//                self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
//            }
//        })
//        
//        //Get Restricted endpoint drug objects
//        ref.child("Restricted").observe(.value, with: { snapshot in
//            var restrictedCount = 0
//            for drugObj in snapshot.children {
//                let drugProp = (drugObj as! FIRDataSnapshot).value as! NSDictionary
//                
//                let pName = drugProp["primaryName"] as! String
//                
//                let nTypeString = drugProp["nameType"] as! String
//                let nType:NameType
//                if (nTypeString == NameType.GENERIC.rawValue) {
//                    nType = NameType.GENERIC
//                } else {
//                    nType = NameType.BRAND
//                }
//                
//                let crit = drugProp["criteria"] as! String
//                
//                let drugClassArr = drugProp["drugClass"] as! NSMutableArray
//                let drugClass = self.trimNSNull(arr: drugClassArr)
//                
//                let altNamesArr = drugProp["alternateName"] as! NSMutableArray
//                let altNames = self.trimNSNull(arr: altNamesArr)
//                
//                let rDrug = RestrictedDrug.init(primaryName: pName, nameType: nType, alternateNames: altNames, criteria: crit, status: Status.RESTRICTED, drugClass: drugClass)
//                
//                self.drugList.append(rDrug)
//                restrictedCount += 1
//            }
//            //done loading all objects
//            self.completedCount += 1
//            print("Restricted drug count:" + String(restrictedCount))
//            //TODO can not put here because of the 3 calls. need to check they are all done before moving on
//            if (self.completedCount == 3){
//                self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
//            }
//        })
//        
//        //Get Formulary endpoint drug objects
//        ref.child("Formulary").observe(.value, with: { snapshot in
//            var formularyCount = 0
//            for drugObj in snapshot.children {
//                let drugProp = (drugObj as! FIRDataSnapshot).value as! NSDictionary
//                
//                let pName = drugProp["primaryName"] as! String
//                
//                let nTypeString = drugProp["nameType"] as! String
//                let nType:NameType
//                if (nTypeString == NameType.GENERIC.rawValue) {
//                    nType = NameType.GENERIC
//                } else {
//                    nType = NameType.BRAND
//                }
//                
//                let drugClassArr = drugProp["drugClass"] as! NSMutableArray
//                let drugClass = self.trimNSNull(arr: drugClassArr)
//                
//                let altNamesArr = drugProp["alternateName"] as! NSMutableArray
//                let altNames = self.trimNSNull(arr: altNamesArr)
//                
//                let strengthArr = drugProp["strengths"] as! NSMutableArray
//                let strengths = self.trimNSNull(arr: strengthArr)
//                
//                let fDrug = FormularyDrug.init(primaryName: pName, nameType: nType, alternateNames: altNames, status: Status.FORMULARY, drugClass: drugClass, strengths: strengths)
//                
//                self.drugList.append(fDrug)
//                formularyCount += 1
//            }
//            //done loading all objects
//            self.completedCount += 1
//            print("Formulary drug count:" + String(formularyCount))
//            //TODO can not put here because of the 3 calls. need to check they are all done before moving on
//            if (self.completedCount == 3){
//                self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
//            }
//        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
