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
                newDrugTable.setValue(drugObj.primaryName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), forKey: "name")
                newDrugTable.setValue(drugObj.nameType.rawValue, forKey: "nameType")
                newDrugTable.setValue(drugObj.status.rawValue, forKey: "status")
                newDrugTable.setValue(dClass.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), forKey: "drugClass")
                do {
                    try context.save()
                }
                catch {
                    print("Could not save:" + drugObj.primaryName)
                }
            }
            
        }
    }
    
    func removeOutdatedEntities(){
        deleteEntries(entityTableName: "DrugTable")
        deleteEntries(entityTableName: "FormularyGeneric")
        deleteEntries(entityTableName: "FormularyBrand")
        deleteEntries(entityTableName: "ExcludedGeneric")
        deleteEntries(entityTableName: "ExcludedBrand")
        deleteEntries(entityTableName: "RestrictedGeneric")
        deleteEntries(entityTableName: "RestrictedBrand")
    }
    
    func saveFirebaseDrugListUpdate(masterDrugList:[DrugBase]){
        print("Attempting to save:" + String(masterDrugList.count))
        for drugEntity in masterDrugList {
            addToDrugTable(drug: drugEntity)
            
            if (drugEntity.status == Status.FORMULARY) {
                addToFormularyTable(drug: drugEntity as! FormularyDrug)
            } else if (drugEntity.status == Status.EXCLUDED) {
                addToExcludedTable(drug: drugEntity as! ExcludedDrug)
            } else {
                addToRestrictedTable(drug: drugEntity as! RestrictedDrug)
            }
        }
    }
    
    func addToDrugTable(drug:DrugBase) {
        //for every drug class
        for dClass in drug.drugClass {
            //primary name save. The master list contains generic and brand names in individual drug objects. Do not save the alternate names here
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "DrugTable", into: context)
            drugEntity.setValue(drug.primaryName, forKey: "name")
            drugEntity.setValue(drug.nameType.rawValue, forKey: "nameType")
            drugEntity.setValue(drug.status.rawValue, forKey: "status")
            drugEntity.setValue(dClass, forKey: "drugClass")
            do {
                try context.save()
            }
            catch {
                print("Could not save: " + drug.primaryName)
            }
        }
    }
    
    func addToFormularyTable(drug:FormularyDrug){
        let pName = drug.primaryName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (drug.nameType == NameType.GENERIC){
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "FormularyGeneric", into: context)
            drugEntity.setValue(pName, forKey: "genericName")
            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "brandName")
            drugEntity.setValue(drug.strengths as [NSString], forKey: "strength")
        } else {
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "FormularyBrand", into: context)
            drugEntity.setValue(pName, forKey: "brandName")
            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "genericName")
            drugEntity.setValue(drug.strengths as [NSString], forKey: "strength")
        }
        do {
            try context.save()
        }
        catch {
            print("Could not save: " + drug.primaryName + " into Formulary")
        }
    }
    
    func addToExcludedTable(drug: ExcludedDrug){
        let pName = drug.primaryName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let crit = drug.criteria.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (drug.nameType == NameType.GENERIC){
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "ExcludedGeneric", into: context)
            drugEntity.setValue(pName, forKey: "genericName")
            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "brandName")
            drugEntity.setValue(crit, forKey: "criteria")
        } else {
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "ExcludedBrand", into: context)
            drugEntity.setValue(pName, forKey: "brandName")
            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "genericName")
            drugEntity.setValue(crit, forKey: "criteria")
        }
        do {
            try context.save()
        }
        catch {
            print("Could not save: " + drug.primaryName + " into Excluded")
        }
    }
    
    func addToRestrictedTable(drug: RestrictedDrug){
        let pName = drug.primaryName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let crit = drug.criteria.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (drug.nameType == NameType.GENERIC){
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "RestrictedGeneric", into: context)
            drugEntity.setValue(pName, forKey: "genericName")
            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "brandName")
            drugEntity.setValue(crit, forKey: "criteria")
        } else {
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "RestrictedBrand", into: context)
            drugEntity.setValue(pName, forKey: "brandName")
            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "genericName")
            drugEntity.setValue(crit, forKey: "criteria")
        }
        do {
            try context.save()
        }
        catch {
            print("Could not save: " + drug.primaryName + " into Excluded")
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
