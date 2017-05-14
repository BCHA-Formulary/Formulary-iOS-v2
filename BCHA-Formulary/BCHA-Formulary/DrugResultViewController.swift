//
//  DrugResultViewController.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-05.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import UIKit

class DrugResultViewController: UITableViewController {
    var drugResult:DrugBase!
    var drugStatus:Status!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
