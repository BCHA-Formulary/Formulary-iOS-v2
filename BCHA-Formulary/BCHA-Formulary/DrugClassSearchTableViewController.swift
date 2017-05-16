//
//  DrugClassSearchTableViewController.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-16.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import UIKit

class DrugClassSearchTableViewController:UITableViewController{
    var drugClassName:String?
    let core = CoreDataHelper.coreMain
    var drugClassSearchNameList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(drugClassName != nil){
            self.title = drugClassName
                drugClassSearchNameList = core.getDrugNamesByDrugClass(drugClassName: drugClassName!).sorted(){ $0 < $1 }
        }
        else{
            self.title = "Drug Class not found"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO if drugClassSearchNameList is zero
        return drugClassSearchNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrugNameCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = drugClassSearchNameList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drugSearched = core.getDrugsFromSaved(drugName: drugClassSearchNameList[indexPath.row])
        let control = self.navigationController?.viewControllers[(navigationController?.viewControllers.count)!-2] as! DrugResultViewController
        control.drugResult = drugSearched
        
        navigationController?.popViewController(animated: true)
    }
}
