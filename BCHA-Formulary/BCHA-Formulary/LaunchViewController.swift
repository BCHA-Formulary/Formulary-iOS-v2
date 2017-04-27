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
    var dataDidLoad = false
    var viewDidActualAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var lastUpdate:String = ""
        if (UserDefaults.standard.string(forKey: StringHelper.LAST_UPDATE_KEY) != nil) {
            lastUpdate = UserDefaults.standard.string(forKey: StringHelper.LAST_UPDATE_KEY)!
        }
        
        firebaseHelper = FirebaseHelper.init()
        firebaseHelper.updateAllEntries(lastUpdated: lastUpdate, completionHandler: { firebaseDrugList, firebaseUpdate in
            if (firebaseDrugList.count == 0) {
                //up to date, no action needed
            } else {
                // update needed
                self.coreDataHelper.removeOutdatedEntities()
                self.coreDataHelper.saveFirebaseDrugListUpdate(masterDrugList: firebaseDrugList, firebaseUpdateDate: firebaseUpdate)
                //TODO save new drug list to core data
                print("Number of drugs to update: " + String(firebaseDrugList.count))
            }
            if (self.viewDidActualAppear){
            self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
            } else {
                self.dataDidLoad = true
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (dataDidLoad) {
            self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
        } else {
            viewDidActualAppear = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
