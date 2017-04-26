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
//        ref.child("message").observeSingleEvent(of: .value, with: { (snapshot) in
//            //DO STUFF HERE
//            let v = snapshot.value as! String
//            print(v)
//            
//        })  { (error) in
//            print(error.localizedDescription)
//        }
//        ref.child("Formulary").observe(.childAdded, with: { (snapshot) -> Void in
//            print(snapshot.value as! String)
//        })
        var count = 0
        ref.child("Formulary").observe(.value, with: { snapshot in
            for _ in snapshot.children {
                count += 1
            }
            print("Formulary count: " + String(count))
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "MainNavControllerSeque", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
