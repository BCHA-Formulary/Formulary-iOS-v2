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
    
    func removeOutdatedEntities(){
        deleteEntries(entityTableName: StringHelper.DRUG_ENTRY_TABLE)
        deleteEntries(entityTableName: StringHelper.FORMUARLY_GENERIC_TABLE)
        deleteEntries(entityTableName: StringHelper.FORMUARLY_BRAND_TABLE)
        deleteEntries(entityTableName: StringHelper.EXCLUDED_GENERIC_TABLE)
        deleteEntries(entityTableName: StringHelper.EXCLUDED_BRAND_TABLE)
        deleteEntries(entityTableName: StringHelper.RESTRICTED_GENERIC_TABLE)
        deleteEntries(entityTableName: StringHelper.RESTRICTED_BRAND_TABLE)
    }
    
    func saveFirebaseDrugListUpdate(masterDrugList:[DrugBase], firebaseUpdateDate:String){
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
        //all records saved, update app timestamp
        saveUpdateLog(firebaseUpdate: firebaseUpdateDate)
    }
    
    func addToDrugTable(drug:DrugBase) {
        //for every drug class
        for dClass in drug.drugClass {
            //primary name save. The master list contains generic and brand names in individual drug objects. Do not save the alternate names here
            let drugEntry = NSEntityDescription.insertNewObject(forEntityName: StringHelper.DRUG_ENTRY_TABLE, into: context) as! DrugEntry
            drugEntry.name = drug.primaryName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            drugEntry.nameType = drug.nameType.rawValue
            drugEntry.status = drug.status.rawValue
            drugEntry.drugClass = getDrugClassIfExist(drugClassName: dClass.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            do {
                try context.save()
            }
            catch {
                print("Could not save:" + drug.primaryName)
            }
        }
    }
    
    func addToFormularyTable(drug:FormularyDrug){
        let pName = drug.primaryName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (drug.nameType == NameType.GENERIC){
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: StringHelper.FORMUARLY_GENERIC_TABLE, into: context) as! FormularyGeneric
            drugEntity.genericName = pName
            drugEntity.brandName = drug.alternateNames as [NSString]
            drugEntity.strength = drug.strengths as [NSString]
        } else {
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "FormularyBrand", into: context) as! FormularyBrand
            drugEntity.brandName = pName
            drugEntity.genericName = drug.alternateNames as [NSString]
            drugEntity.strength = drug.strengths as [NSString]
//            drugEntity.setValue(pName, forKey: "brandName")
//            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "genericName")
//            drugEntity.setValue(drug.strengths as [NSString], forKey: "strength")
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
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "ExcludedGeneric", into: context) as! ExcludedGeneric
            drugEntity.genericName = pName
            drugEntity.brandName = drug.alternateNames as [NSString]
            drugEntity.criteria = crit
//            drugEntity.setValue(pName, forKey: "genericName")
//            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "brandName")
//            drugEntity.setValue(crit, forKey: "criteria")
        } else {
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "ExcludedBrand", into: context) as! ExcludedBrand
            drugEntity.brandName = pName
            drugEntity.genericName = drug.alternateNames as [NSString]
            drugEntity.criteria = crit
//            drugEntity.setValue(pName, forKey: "brandName")
//            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "genericName")
//            drugEntity.setValue(crit, forKey: "criteria")
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
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "RestrictedGeneric", into: context) as! RestrictedGeneric
            drugEntity.genericName = pName
            drugEntity.brandName = drug.alternateNames as [NSString]
            drugEntity.criteria = crit
//            drugEntity.setValue(pName, forKey: "genericName")
//            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "brandName")
//            drugEntity.setValue(crit, forKey: "criteria")
        } else {
            let drugEntity = NSEntityDescription.insertNewObject(forEntityName: "RestrictedBrand", into: context) as! RestrictedBrand
            drugEntity.brandName = pName
            drugEntity.genericName = drug.alternateNames as [NSString]
            drugEntity.criteria = crit
//            drugEntity.setValue(pName, forKey: "brandName")
//            drugEntity.setValue(drug.alternateNames as [NSString], forKey: "genericName")
//            drugEntity.setValue(crit, forKey: "criteria")
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
    
    func saveUpdateLog(firebaseUpdate:String) {
        UserDefaults.standard.set(firebaseUpdate, forKey: StringHelper.LAST_UPDATE_KEY)
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
    
    func getDrugClassIfExist(drugClassName:String) -> DrugClass {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:StringHelper.DRUG_CLASS_TABLE)
        fetchReq.returnsObjectsAsFaults = false
        fetchReq.predicate = NSPredicate(format: "drugClass = %@", drugClassName)
        
        var dClass:DrugClass
        do {
            let fetchedClass = try context.fetch(fetchReq)
            if (fetchedClass.count > 0){
                dClass = fetchedClass[0] as! DrugClass
            } else {
                dClass = NSEntityDescription.insertNewObject(forEntityName: StringHelper.DRUG_CLASS_TABLE, into: context) as! DrugClass
                dClass.drugClass = drugClassName
            }
        } catch {
            dClass = NSEntityDescription.insertNewObject(forEntityName: StringHelper.DRUG_CLASS_TABLE, into: context) as! DrugClass
            dClass.drugClass = drugClassName
        }
        return dClass
    }
    
    func getAllDrugNames() -> [String] {
        var drugNames = Set<String>()
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:StringHelper.DRUG_ENTRY_TABLE)
        fetchReq.returnsObjectsAsFaults = false
        do {
            let fetchedDrugs = try context.fetch(fetchReq)
            if(fetchedDrugs.count > 0){
                for drug in fetchedDrugs as! [DrugEntry]{
                    drugNames.insert(drug.name!)
                }
            } else {
                print("Could not find any drugs")
                //TODO throw error reload drugs
            }
        } catch {
            print("Could not get any drugs")
            //TODO Throw error reload drugs
        }
        return Array(drugNames)
    }
    
    func doesDrugExist(drugName:String) -> Bool {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:StringHelper.DRUG_ENTRY_TABLE)
        fetchReq.returnsObjectsAsFaults = false
        fetchReq.predicate = NSPredicate(format:"name = %@", drugName)
        do {
            let fetchReq = try context.fetch(fetchReq)
            return fetchReq.count > 0
        }
        catch {
            print("Error searching for drug: " + drugName)
            return false
        }
    }
    
    func getDrugFromSaved(drugName:String) -> DrugBase? {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:StringHelper.DRUG_ENTRY_TABLE)
        fetchReq.returnsObjectsAsFaults = false
        fetchReq.predicate = NSPredicate(format:"name = %@", drugName)
        do {
            let fetchReq = try context.fetch(fetchReq)
            if (fetchReq.count > 0){
                let drugEntry = fetchReq[0] as! DrugEntry
                var foundDrug:DrugBase
                if drugEntry.status == Status.FORMULARY.rawValue {
                    foundDrug = getFormularyDrug(drugEntry: drugEntry)!
                }
//                else if drugEntry.status == Status.EXCLUDED.rawValue {
//                    foundDrug = getExcludedDrug(drugEntry: drugEntry)
//                }
//                else {
//                    foundDrug = getRestrictedDrug(drugEntry: drugEntry)
//                }
                return nil
            }
        }
        catch {
            print("Error searching for drug: " + drugName)
            return nil
        }
        return nil
    }
    
//    private func getFormularyDrug(drugEntry:DrugEntry) -> FormularyDrug {
    private func getFormularyDrug(drugEntry:DrugEntry) -> FormularyDrug? {
        let isGeneric = (drugEntry.nameType == NameType.GENERIC.rawValue)
        var formularyTable:String
        if isGeneric {
            formularyTable = StringHelper.FORMUARLY_GENERIC_TABLE
        } else {
            formularyTable = StringHelper.FORMUARLY_BRAND_TABLE
        }
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:formularyTable)
        fetchReq.returnsObjectsAsFaults = false
        do {
            if isGeneric {
                fetchReq.predicate = NSPredicate(format:"genericName = %@", drugEntry.name!)
            } else {
                fetchReq.predicate = NSPredicate(format:"brandName = %@", drugEntry.name!)
            }
            
            let fetchReq = try context.fetch(fetchReq)
            
            if fetchReq.count > 0 {
                if isGeneric{
                    let fGen = fetchReq[0] as! FormularyGeneric
                    let fBrand = fGen.brandName! as [String]
                    print(fBrand[0])
                } else {
                    
                }
            }
            
        }
        catch {
            
        }
        return nil
    }
    
//    private func getExcludedDrug(drugEntry:DrugEntry) -> ExcludedDrug {
//        
//    }
//    
//    private func getRestrictedDrug(drugEntry:DrugEntry) -> RestrictedDrug {
//        
//    }
}
