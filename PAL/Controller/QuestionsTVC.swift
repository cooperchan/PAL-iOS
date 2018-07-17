//
//  QuestionsTVC.swift
//  PAL
//
//  Created by admin on 6/20/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionsTVC: UITableViewController {

    //Variable to hold questions
    var forms: [Post] = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user_id = UserDefaults.standard.integer(forKey: "user_id")

        self.getForms()
        
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
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
        
            //WORK ON THIS!!!!!!!!!!!!!!
            //Save Submission ID
//            let submission_id = 14
//            UserDefaults.standard.set(submission_id, forKey: "submission_id")
//            UserDefaults.standard.synchronize()
        }
    }
    
    // Submission ID - 4, 14, 15 - responseJSON["id"]
    // Submission ID - 0         - response["id"]

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = submissions_id[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        print(id)
        
        UserDefaults.standard.set(id, forKey: "submission_id")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "toQuestion", sender: nil)
    }
    
    @objc func logOut() {
        checker = true
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "homepage_nav") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
}
