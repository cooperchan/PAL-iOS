//
//  AssignFormsTVC.swift
//  PAL
//
//  Created by admin on 7/6/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 This controllers shows the list of students currently assigned to that counselor
 */
class StudentListTVC: UITableViewController {
    
    var studentList: [Post] = [Post]()
    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Get the counselor ID
        counselor_id = UserDefaults.standard.integer(forKey: "counselor_id")
        print("Counselor ID is: \(counselor_id!)")
        
        self.getList()
    }
    
    //Get the list of students based off counselor ID, save to array
    func getList() {
        Service().getStudentsForCounselor(user_id: counselor_id!){ (response) in
            //Append data to array
            for(_, responseJSON):(String, JSON) in response {
                //Get and save student name in a Post array
                let student = Post(student: responseJSON["name"].stringValue)
                self.studentList.append(student)
                
                //Get and save student ID in Int array
                let ID = responseJSON["id"].intValue
                student_id.append(ID)
                
                //Save array of student IDs in global variable
                let defaults = UserDefaults.standard
                defaults.set(student_id, forKey: "SavedIntArray")
                UserDefaults.standard.synchronize()
            }
            //Reload table after for-loop, gets recent data
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let form = self.tableView.dequeueReusableCell(withIdentifier: "some", for: indexPath) as! StudentsCell
        
        let post = self.studentList[indexPath.row]
        
        form.names.text = post.student!
        
        return form
    }
    
    /*
     Lets each student name be tappable
     Each ID is the student ID and saves it for the assigning forms
     Goes to the CounselorActitivies when pressed
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(student_id[indexPath.row])
        let id = student_id[indexPath.row]
        print(id)
        tableView.deselectRow(at: indexPath, animated: true)
        
        UserDefaults.standard.set(id, forKey: "student_id")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "toActions", sender: nil)
    }

}
