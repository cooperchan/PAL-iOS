//
//  RegisterVC.swift
//  PAL
//
//  Created by Mackensie Alvarez on 6/10/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON
class RegisterVC: UIViewController {

    
    
    //email, full name, password, confirm password
    // DoB, school, school_id, grad_year, gender, phone_number, counseler_id
    
    //MARK: Variables
        //Required Items
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
        //Optional Items
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var schoolID: UITextField!
    @IBOutlet weak var counselorID: UITextField!
    @IBOutlet weak var graduationYear: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    var gender: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gender = ""
        school.text = ""
        schoolID.text = ""
        counselorID.text = ""
        graduationYear.text = ""
        phoneNumber.text = ""
    }

    @IBAction func radioMale(_ sender: Any) {
        gender = "Male"
    }
    
    @IBAction func radioFemale(_ sender: Any) {
        gender = "Female"
    }
    
    @IBAction func radioOther(_ sender: Any) {
        gender = "Other"
    }
    
    //MARK: Register
    @IBAction func register(_ sender: Any) {
        let fullName: String! = firstName.text! + " " + lastName.text!
        
        if password.text != confirmPass.text {
            _ = SweetAlert().showAlert("Error", subTitle: "Passwords do not match", style: .error)
        } else if firstName.text! == "" || lastName.text! == "" || email.text! == "" || confirmPass.text! == "" || password.text! == "" {
            _ = SweetAlert().showAlert("Error", subTitle: "One or more required fields is empty", style: .error)
        } else {
            //Remember to include birthdate
            let parameters: [String: String] = ["name": fullName, "email": email.text!, "password": password.text!, "gender": gender, "school": school.text!, "school_id": schoolID.text!, "counselor_id": counselorID.text!, "grad_year": graduationYear.text!, "phone_number": phoneNumber.text! ]
        
            Service().register(parameters: parameters) { (response) in
                print(response)
                
                if response["status"].intValue == 1 {
                  _ = SweetAlert().showAlert("Success", subTitle: "User created successfully", style: .success)

                    
                    
                    //Go to the main screen and also save the user id

                    let user_id = response["message"].intValue
                    print(user_id)

                    //Save
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                    UserDefaults.standard.synchronize()
                    
                    //Go back to login once user is created
                    self.performSegue(withIdentifier: "regToLogin", sender: nil)

                } else {
                    // Error and display message
                    print("ERROR: \(response["message"].stringValue)")
                   _ = SweetAlert().showAlert("Error", subTitle: "\(response["message"].stringValue)", style: .error)
                }
            }
        }
    }
}
