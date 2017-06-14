//
//  NoDrugFoundViewController.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-14.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import UIKit

class NoDrugFoundViewController:UIViewController{
    var drugSearched:String!
    
    @IBOutlet weak var drugNameTitle: UILabel!
    @IBOutlet weak var viewFormularyBttn: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "DRUG NOT FOUND"
        drugNameTitle.text = "Sorry, " + drugSearched + " was not found."
        
        //TODO figure out what to do with button. Hide for now
        viewFormularyBttn.isHidden = true
    }
}
