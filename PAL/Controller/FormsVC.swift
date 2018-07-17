//
//  FormsVC.swift
//  PAL
//
//  Created by admin on 7/5/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

class FormsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var viewForms: [Post] = [Post]()
    var questionName = "question"
    
    
    @IBOutlet weak var seg: UISegmentedControl!
    
    @IBOutlet weak var formsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData(formNum: 30)
    }

    func loadData(formNum: Int) {
        Service().getFormByID(form_id: formNum) { (response) in
            for(_, responseJSON):(String, JSON) in response {
                let form = Post(question: responseJSON["question"].stringValue)
                self.viewForms.append(form)
                
                //print(self.viewForms)
                //print(self.viewForms[0])
            }
            
             self.formsTable.reloadData()
        }
        //print(viewForms)
        
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        questionName = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        viewForms.removeAll()
        if questionName == "Weekly" {
            loadData(formNum: 30)
        } else if questionName == "Daily" {
            loadData(formNum: 38)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewForms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.formsTable.dequeueReusableCell(withIdentifier: "formsCell", for: indexPath)
        let formtype = viewForms[indexPath.row]
       
        cell.textLabel?.text = formtype.question!
        
        return cell
    }
    


    @IBAction func assignFormButt(_ sender: Any) {
        
        self.assignForm()
    }
    
    func assignForm() {
        //let weekly_fid = 30
        //let daily_fid = 38
        
        let studID = UserDefaults.standard.integer(forKey: "student_id")
        
        if  seg.selectedSegmentIndex == 0 {
        Service().registerSubmission(user_id: studID, form_id: 30) { (response) in
            _ = SweetAlert().showAlert("Success", subTitle: "Form has been assigned", style: .success)
            }
            print("weekly assigned")
        }
        else if seg.selectedSegmentIndex == 1 {
            Service().registerSubmission(user_id: studID, form_id: 38) { (response) in
                _ = SweetAlert().showAlert("Success", subTitle: "Form has been assigned", style: .success)
            }
            print("daily assigned")
        }
        
       
    }
}

    

