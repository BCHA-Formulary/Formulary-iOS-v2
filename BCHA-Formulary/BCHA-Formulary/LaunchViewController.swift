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

class LaunchViewController: UIViewController {
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        ref.child("Excluded").observe(.value, with: { snapshot in
            for child in snapshot.children {
                let dict = (child as! FIRDataSnapshot).value as! NSDictionary
                let name = dict["primaryName"] as! String
                print(name)
            }
//            let enumerator = snapshot.children
//            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
////                print(rest.value!)
//                let name = rest.value(forKey: "primaryName")
//                print(name!)
//            }
            //TODO can not put here because of the 3 calls. need to check they are all done before moving on
            self.performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
