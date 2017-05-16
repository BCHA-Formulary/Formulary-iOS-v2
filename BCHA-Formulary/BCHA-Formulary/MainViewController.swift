//
//  ViewController.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-04-25.
//  Copyright © 2017 BCHA. All rights reserved.
//

import UIKit
import SearchTextField

class MainViewController: UIViewController {
    let core = CoreDataHelper.coreMain
    @IBOutlet weak var drugSearchTextField: SearchTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let drugNames = core.getAllDrugNames()
        drugSearchTextField.filterStrings(drugNames)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prep segue")
        if (segue.identifier == "DrugResultSegue") {
            let svc = segue.destination as! DrugResultViewController;
            
            // Drug exists at this point
            svc.drugResult = core.getDrugsFromSaved(drugName: drugSearchTextField.text!.uppercased())
        }
        else if (segue.identifier == "NoDrugResultSegue"){
            let svc = segue.destination as! NoDrugFoundViewController
            
            if(drugSearchTextField != nil){
                svc.drugSearched = drugSearchTextField.text
            }
        }
    }

    @IBAction func searchTapped(_ sender: UIButton) {
        //no text entered check
        if (drugSearchTextField.text?.isEmpty)!{
            print("No text entered")
            return
        }
        
        print("Searching for drug:" + drugSearchTextField.text!)
        if core.doesDrugExist(drugName: drugSearchTextField.text!.uppercased()) {
         //TODO go to result view
             performSegue(withIdentifier: "DrugResultSegue", sender: self)
        }
        else {
            //TODO go to no drug found view
            performSegue(withIdentifier: "NoDrugResultSegue", sender: self)
        }
    }
}
