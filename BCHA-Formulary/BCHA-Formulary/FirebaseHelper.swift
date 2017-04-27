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
    
    func updateAllEntries(lastUpdated:String, completionHandler: @escaping ([DrugBase])->Void) {
//        if (lastUpdated == "") {
//            completionHandler(getFirebaseDrugList())
//        } else {
            var firebaseLastUpdate:String = "none"
            ref.child("Update").observeSingleEvent(of: .value, with: {(snapshot) in
                firebaseLastUpdate = snapshot.value as! String
                if(firebaseLastUpdate != lastUpdated) {
                    completionHandler(self.getFirebaseDrugList())
                }
            }) { (error) in
                print(error.localizedDescription)
            }
//        }
    }
    
    
    func getFirebaseDrugList() -> [DrugBase]{
        //TODO
        return [DrugBase]()
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
    
    
}
