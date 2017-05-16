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
    var strengthList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //drug check
        if (drugResult == nil) {
            //TODO prompt error message
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        //order strength list if formulary
        if(drugResult.status == Status.FORMULARY){
            strengthList = (drugResult as! FormularyDrug).strengths.sorted(){$0 < $1}
        }
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(drugResult.status == Status.FORMULARY){
            self.title = (drugResult as! FormularyDrug).primaryName
        }
        else if(drugResult.status == Status.EXCLUDED){
            self.title = (drugResult as! ExcludedDrug).primaryName
        }
        else{
            self.title = (drugResult as! RestrictedDrug).primaryName
        }
        
        tableView.reloadData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4 //alt names, status, strength/criteria, drugclasses
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DrugClassSearchSegue") {
            //going to drug search by class
            self.navigationController?.isNavigationBarHidden = false
            let drugSearchViewController = segue.destination as! DrugClassSearchTableViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                drugSearchViewController.drugClassName = drugResult.drugClass[indexPath.row]
            }
        }
        else{
            //going back to main search page
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Alternate Name(s)"
        }
        else if (section == 1){
            return "Drug Status"
        }
        else if (section == 2){
            if(drugResult.status == Status.FORMULARY){
                return "Strengths"
            }
            else{
                return "Reason for Exclusion"
            }
        }
        else{
            return "Drug Class(es)"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            if (drugResult.status == Status.FORMULARY){
                return (drugResult as! FormularyDrug).alternateNames.count
            }
            else if(drugResult.status == Status.EXCLUDED){
                return(drugResult as! ExcludedDrug).alternateNames.count
            }
            else{
                return(drugResult as! RestrictedDrug).alternateNames.count
            }
        }
        else if (section == 1){
            return 1
        }
        else if(section == 2){
            if (drugResult.status == Status.FORMULARY){
                return (drugResult as! FormularyDrug).strengths.count
            }
            else{
                return 1
            }
        }
        else{
            return drugResult.drugClass.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        if(indexPath.section == 3){
            cell = tableView.dequeueReusableCell(withIdentifier: "DrugClass cell", for: indexPath) as UITableViewCell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "Data cell", for: indexPath) as UITableViewCell
        }
        
        if(indexPath.section == 0){
            if (drugResult.status == Status.FORMULARY){
                let data = (drugResult as! FormularyDrug).alternateNames[indexPath.row]
                cell.textLabel?.text = data
            }
            else if(drugResult.status == Status.EXCLUDED){
                let data = (drugResult as! ExcludedDrug).alternateNames[indexPath.row]
                cell.textLabel?.text = data
            }
            else{
                let data = (drugResult as! RestrictedDrug).alternateNames[indexPath.row]
                cell.textLabel?.text = data
            }
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else if(indexPath.section == 1){
            cell.textLabel?.text = drugResult.status.rawValue
            if(drugResult.status == Status.FORMULARY){
                cell.textLabel?.textColor = UIColor.black
            }
            else{
                cell.textLabel?.textColor = UIColor.red
            }
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else if(indexPath.section == 2){
            if (drugResult.status == Status.FORMULARY){
                let data = strengthList[indexPath.row]
                cell.textLabel?.text = data
            }
            else if(drugResult.status == Status.EXCLUDED){
                let data = (drugResult as! ExcludedDrug).criteria
                cell.textLabel?.text = data
                
            }
            else{
                let data = (drugResult as! RestrictedDrug).criteria
                cell.textLabel?.text = data
            }
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else{
            let data = drugResult.drugClass[indexPath.row]
            cell.textLabel?.text = data
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if(indexPath.section == 3){
            return indexPath
        }
        else{
            return nil
        }
    }
}
