//
//  UpdateCounselorProfileVC.swift
//  PAL
//
//  Created by admin on 7/2/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

/*
 This controller handles the update page for the counselor
 It allows them to change most information, except their email
*/
class UpdateCounselorProfileVC: UIViewController {
    
    //MARK: Variables
    @IBOutlet weak var counselorFirstName: UITextField!
    @IBOutlet weak var counselorLastName: UITextField!
    @IBOutlet weak var counselorPhoneNumber: UITextField!
    @IBOutlet weak var counselorBirthMonth: UITextField!
    @IBOutlet weak var counselorBirthDay: UITextField!
    @IBOutlet weak var counselorBirthYear: UITextField!
    @IBOutlet weak var counselorSchool: UITextField!
    @IBOutlet weak var counselorSchoolID: UITextField!
    @IBOutlet weak var counselorsID: UITextField!
    
    var counselorGender: String!
    var counselorBirthdate: String!
    
    //MARK: Constant
    @IBOutlet weak var counselorEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Get the user ID
        user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        //Set inital fields to blank
        counselorPhoneNumber.text = ""
        counselorSchool.text = ""
        counselorSchoolID.text = ""
        counselorsID.text = ""
        counselorGender = ""
        counselorBirthdate = ""
        
        getData()
        
        //Log Out Prompt
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }

    //Buttons for 3 genders
    @IBAction func radioBtnMale(_ sender: Any) {
        counselorGender = "Male"
    }
    
    @IBAction func radioBtnFemale(_ sender: Any) {
        counselorGender = "Female"
    }
    
    @IBAction func radioBtnOther(_ sender: Any) {
        counselorGender = "Other"
    }
    
    //Gets the counselors email
    func getData() {
        Service().userProfile(user_id: user_id!) { (json) in
            self.counselorEmail.text = "Email: \(json["email"].stringValue)"
        }
    }
    
    //Calls update profile 
    @IBAction func updateCounselorProfile(_ sender: Any) {
        let counselorFullName: String! = counselorFirstName.text! + " " + counselorLastName.text!
        counselorBirthdate = counselorBirthYear.text! + "-" + counselorBirthMonth.text! + "-" + counselorBirthDay.text!
        if(counselorBirthdate == "--") {
            counselorBirthdate = ""
        }
        
        let parameters: [String: String] = ["name": counselorFullName, "birth_date": counselorBirthdate, "gender": counselorGender, "school": counselorSchool.text!, "school_id": counselorSchoolID.text!, "counselor_id": counselorsID.text!, "phone_number": counselorPhoneNumber.text! ]
        
        Service().userUpdateProfile(user_id: user_id!, parameters: parameters)  { (json) in
            if json["status"].intValue == 1 {
                //Show Popup of User Success
                _ = SweetAlert().showAlert("Success", subTitle: "User Profile has been updated", style: .success)
                //Go back to Profile Page
                self.performSegue(withIdentifier: "updateToCounselorProfile", sender: nil)
            } else {
                // Error and display message
                print("ERROR: \(json["message"].stringValue)")
                _ = SweetAlert().showAlert("Error", subTitle: "\(json["message"].stringValue)", style: .error)
            }
        }
    }
    
    /*
     Allows the user to logout, sending them back to inital landing page
     THe checker ensures that the About Info doesn't popup again
     Also closes connection to chatroom
     */
    @objc func logOut(_ sender:UIBarButtonItem!) {
        checker = true
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "homepage_nav") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
        
        CounselorChatRoomVC.sharedInstance.closeConnection()
    }
    
}
