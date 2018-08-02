//
//  FormAnswersTVC.swift
//  PAL
//
//  Created by admin on 7/10/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubmittedFormsTVC: UITableViewController {

    var listOfStudents: [Post] = [Post]()
    var listOfForms: [Post] = [Post]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        counselor_id = UserDefaults.standard.integer(forKey: "counselor_id")
        self.getStudentNameAndForm()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfStudents.count;
    }
    
    func getStudentNameAndForm() {
        Service().getStudentAndForm(counselor_id: counselor_id!){ (response) in
            
           
            for(_, responseJSON):(String, JSON) in response {
                
                let sName = Post(student: responseJSON["name"].stringValue)
                self.listOfStudents.append(sName)
                
                let fName = Post(form: responseJSON["form_name"].stringValue)
                self.listOfForms.append(fName)
                
                let savedID = responseJSON["id"].intValue
                submissions_id.append(savedID)
                
                //Save array of student IDs in global variable
                let defaults = UserDefaults.standard
                defaults.set(submissions_id, forKey: "SavedIDArray")
                UserDefaults.standard.synchronize()
            }
            
            self.tableView.reloadData()
        }
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let submittedForm = self.tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath) as! SubmittedAnswersCell
        
        let firstLabel = self.listOfStudents[indexPath.row]
        let secondLabel = self.listOfForms[indexPath.row]
        
        
        submittedForm.studentNames.text = firstLabel.student!
        submittedForm.formNames.text = secondLabel.form!
        
        return submittedForm
    }
    
    /*
     Lets each submitted form be tappable
     Each ID is the submitted ID and saves it
     Goes to the QuestionAnswersTVC when pressed
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let submittedId = submissions_id[indexPath.row]
        print(submittedId)
        tableView.deselectRow(at: indexPath, animated: true)
        
        UserDefaults.standard.set(submittedId, forKey: "submissions_id")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "toQA", sender: nil)
    }
  
    
    }

