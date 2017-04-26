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
    var ref: FIRDatabaseReference!
    var drugList = [DrugBase]()
    var completedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set firebase for retrieve data
        ref = FIRDatabase.database().reference()
        //Get Excluded endpoint drug objects
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
                
                self.drugList.append(eDrug)
                excludedDrugs.append(eDrug) //TODO testing - remove later
                excludedCount += 1
            }
            //done loading all objects
            self.completedCount += 1
            print("Excluded drug count:" + String(excludedCount))
            //TODO - testing core data
//            self.saveToDrugTable(drugList: excludedDrugs)
//            self.deleteEntries(entityTableName:"DrugTable")
            self.fetchByAttribute(entityTableName: "DrugTable")
            //TODO can not put here because of the 3 calls. need to check they are all done before moving on
            if (self.completedCount == 3){
                self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
            }
        })
        
        //Get Restricted endpoint drug objects
        ref.child("Restricted").observe(.value, with: { snapshot in
            var restrictedCount = 0
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
                
                self.drugList.append(rDrug)
                restrictedCount += 1
            }
            //done loading all objects
            self.completedCount += 1
            print("Restricted drug count:" + String(restrictedCount))
            //TODO can not put here because of the 3 calls. need to check they are all done before moving on
            if (self.completedCount == 3){
                self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
            }
        })
        
        //Get Formulary endpoint drug objects
        ref.child("Formulary").observe(.value, with: { snapshot in
            var formularyCount = 0
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
                
                let drugClassArr = drugProp["drugClass"] as! NSMutableArray
                let drugClass = self.trimNSNull(arr: drugClassArr)
                
                let altNamesArr = drugProp["alternateName"] as! NSMutableArray
                let altNames = self.trimNSNull(arr: altNamesArr)
                
                let strengthArr = drugProp["strengths"] as! NSMutableArray
                let strengths = self.trimNSNull(arr: strengthArr)
                
                let fDrug = FormularyDrug.init(primaryName: pName, nameType: nType, alternateNames: altNames, status: Status.FORMULARY, drugClass: drugClass, strengths: strengths)
                
                self.drugList.append(fDrug)
                formularyCount += 1
            }
            //done loading all objects
            self.completedCount += 1
            print("Formulary drug count:" + String(formularyCount))
            //TODO can not put here because of the 3 calls. need to check they are all done before moving on
            if (self.completedCount == 3){
                self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     *   Due to the nature of adding/deleting firebase array elements, the indexing of some lists
     *   may include some elements in the NSArray which are NSNull, these are elements we do NOT
     *   want to include in our objects and tables so are filtered out before creating them
     */
    //TODO move this function to a better place
    func trimNSNull(arr:NSMutableArray) -> [String] {
        var stringArr = [String]()
        for element in arr {
            if let e  = element as? String {
                stringArr.append(e)
            }
        }
        return stringArr
    }
    
    func saveToDrugTable(drugList:[DrugBase]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        
        for drugObj in drugList {
            print("Attemting to save:" + drugObj.primaryName)
            for dClass in drugObj.drugClass {
                let newDrugTable = NSEntityDescription.insertNewObject(forEntityName: "DrugTable", into: context)
                newDrugTable.setValue(drugObj.primaryName, forKey: "name")
                newDrugTable.setValue(drugObj.nameType.rawValue, forKey: "nameType")
                newDrugTable.setValue(drugObj.status.rawValue, forKey: "status")
                newDrugTable.setValue(dClass, forKey: "drugClass")
                do {
                    try context.save()
                }
                catch {
                    print("Could not save:" + drugObj.primaryName)
                }
            }
            
        }
    }
    
    func deleteEntries(entityTableName:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName:entityTableName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        }catch {
            print("Could not delete entities")
        }
    }
    
    func fetchByAttribute(entityTableName:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:entityTableName)
        
        fetchReq.predicate = NSPredicate(format: "nameType = %@", NameType.BRAND.rawValue)
        fetchReq.returnsObjectsAsFaults = false //see the results as you put into core data
        
        do {
            let fetchedDrugs = try context.fetch(fetchReq)
            
            if fetchedDrugs.count > 0 {
                print("Brand count" + String(fetchedDrugs.count))
            }
        } catch {
            print("Could not fetch drug")
        }
    }
}
