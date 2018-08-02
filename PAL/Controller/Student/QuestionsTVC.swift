//
//  QuestionsTVC.swift
//  PAL
//
//  Created by admin on 6/20/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 This is the Forms Page for the student, it displays all available forms the student must compelete
 Tapping on a form will change the controller to QuestionsVC for the appropriate form
 It is part of a tab bar and nav bar, allowing them to switch between Profile, Forms, and Chat
 */
class QuestionsTVC: UITableViewController {

    //Variable to hold questions
    var forms: [Post] = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get User ID
        user_id = UserDefaults.standard.integer(forKey: "user_id")

        self.getForms()
    }
    
    //Gets all available form names and saves them in an array of Post
    func getForms() {
        Service().getAvailableSubmission(user_id: user_id!) { (response) in
            for(_, responseJSON):(String, JSON) in response {
                let form = Post(form: responseJSON["name"].stringValue)
                self.forms.append(form)
                
                let submission = responseJSON["id"].intValue
                submissions_id.append(submission)
                
                let defaults = UserDefaults.standard
                defaults.set(submissions_id, forKey: "SavedSubArray")
                UserDefaults.standard.synchronize()
            }
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return forms.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let form = self.tableView.dequeueReusableCell(withIdentifier: "form", for: indexPath) as! QuestionsCell
    
        let post = self.forms[indexPath.row]

        //form.button.setTitle("\(post.form!)", for: .normal)
        
        form.formLabel.text = post.form!
        
        return form
    }
    
    /*
    Lets each form name be tappable
    Each ID is the form ID and saves it for the Questions VC
    Goes to the QuestionsVC when pressed
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = submissions_id[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        print(id)
        
        UserDefaults.standard.set(id, forKey: "submission_id")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "toQuestion", sender: nil)
    }
}
