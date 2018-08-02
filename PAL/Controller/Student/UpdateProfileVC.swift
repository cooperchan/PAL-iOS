//
//  UpdateProfileVC.swift
//  PAL
//
//  Created by admin on 6/18/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

/*
 This controller handles the update page for the student
 It allows them to change most information, except their email
 */
class UpdateProfileVC: UIViewController {

    //MARK: Variables
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var birthMonth: UITextField!
    @IBOutlet weak var birthDay: UITextField!
    @IBOutlet weak var birthYear: UITextField!
    
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var schoolID: UITextField!
    @IBOutlet weak var graduationYear: UITextField!
    @IBOutlet weak var counselorID: UITextField!
    var gender: String!
    var birthdate: String!
    //MARK: Constant
    @IBOutlet weak var email: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Get User ID
        user_id = UserDefaults.standard.integer(forKey: "user_id")
        
        //Set the inital fields to blank
        gender = ""
        birthdate = ""
        school.text = ""
        schoolID.text = ""
        counselorID.text = ""
        graduationYear.text = ""
        phoneNumber.text = ""
        
        getData()
        
        //Log Out Prompt
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    //Gender Buttons
    @IBAction func radioMale(_ sender: Any) {
        gender = "Male"
    }
    
    @IBAction func radioFemale(_ sender: Any) {
        gender = "Female"
    }
    
    @IBAction func radioOther(_ sender: Any) {
        gender = "Other"
    }
    
    //Displays the email
    func getData() {
        Service().userProfile(user_id: user_id!) { (json) in
            self.email.text = "Email: \(json["email"].stringValue)"
        }
    }
    
    //Mark: Update Profile
    @IBAction func updateProfile(_ sender: Any) {
        let fullName: String! = firstName.text! + " " + lastName.text!
        birthdate = birthYear.text! + "-" + birthMonth.text! + "-" + birthDay.text!
        if(birthdate == "--") {
            birthdate = ""
        }
        
        let parameters: [String: String] = ["name": fullName, "birth_date": birthdate, "gender": gender, "school": school.text!, "school_id": schoolID.text!, "counselor_id": counselorID.text!, "grad_year": graduationYear.text!, "phone_number": phoneNumber.text! ]
     
        Service().userUpdateProfile(user_id: user_id!, parameters: parameters)  { (json) in
            if json["status"].intValue == 1 {
                //Show Popup of User Success
                _ = SweetAlert().showAlert("Success", subTitle: "User Profile has been updated", style: .success)
                //Go back to Profile Page
                self.performSegue(withIdentifier: "updateToProfile", sender: nil)
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
    @objc func logOut() {
        checker = true
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "homepage_nav") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
        
        StudentChatRoomVC.sharedInstance.closeConnection()
    }
}

