//
//  CoreDataHelper.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-04-26.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    private let appDelegate: AppDelegate
    private let context:NSManagedObjectContext
    static let coreMain:CoreDataHelper = CoreDataHelper() //singleton core data
    
    private init () {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    /*
     * Core Data Table: UpdatedLog
     * Returns the last instance of the time the app was recorded to be updated.
     * Returns "" if no record is found
     */
    func lastUpdated() -> String{
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:"UpdatedLog")
        
        fetchReq.returnsObjectsAsFaults = false //see the results as you put into core data
        
        do {
            let fetchUpdate = try context.fetch(fetchReq) as! [String]
            
            if fetchUpdate.count > 0 {
                print("Last updated: " + fetchUpdate[0])
                return fetchUpdate[0]
            } else {
                print("No last updated found")
            }
        } catch {
            print("Could not fetch update")
        }
        return ""
    }
    
    func saveToDrugTable(drugList:[DrugBase]) {
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
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName:entityTableName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        }catch {
            print("Could not delete entities")
        }
    }
    
    func fetchByAttribute(entityTableName:String){
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
