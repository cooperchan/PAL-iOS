//
//  RegisterVC.swift
//  PAL
//
//  Created by Mackensie Alvarez on 6/10/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 This is the controller for the register page
 It allows the user to enter their information and sign up for the app
 */
class RegisterVC: UIViewController {

    
    
    var aboutText: String! = "Welcome to PAL. Your Path to Assisted Living! This app is designed as a tol to maintain communication between student and counselor. With PAL, users are able to create profiles, participate in questionnaires and an instant messaging system. The main goal of PAL is to build a orad to fostering emotional well-being. Here at PAL, we hope to improve your life one step at a time."
    
    //MARK: Variables
    //These variables are what the user has to enter
    //Seperated by what is required and what is optional
        //Required Items
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
        //Optional Items
    @IBOutlet weak var birthMonth: UITextField!
    @IBOutlet weak var birthDay: UITextField!
    @IBOutlet weak var birthYear: UITextField!
    @IBOutlet weak var school: UITextField!
    @IBOutlet weak var schoolID: UITextField!
    @IBOutlet weak var counselorID: UITextField!
    @IBOutlet weak var graduationYear: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    var gender: String!
    var birthdate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set the initial text to nothing
        gender = ""
        birthdate = ""
        school.text = ""
        schoolID.text = ""
        counselorID.text = ""
        graduationYear.text = ""
        phoneNumber.text = ""
        
        //About Prompt
        let rightBarButton = UIBarButtonItem(title: "About", style: UIBarButtonItemStyle.plain, target: self, action: #selector(about))
        self.navigationItem.rightBarButtonItem = rightBarButton
    
    }

//These radio buttons allow the user to choose between 3 genders
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
    /*
     When button is pressed, combine the first and last name as well as birthdays
     Check if password is the same as confirm
     Check if all required fields aren't left blank
     Store all info in array and Pass All Info to Server
     */
    @IBAction func register(_ sender: Any) {
        let fullName: String! = firstName.text! + " " + lastName.text!
        birthdate = birthYear.text! + "-" + birthMonth.text! + "-" + birthDay.text!
        
        if password.text != confirmPass.text {
            _ = SweetAlert().showAlert("Error", subTitle: "Passwords do not match", style: .error)
        } else if firstName.text! == "" || lastName.text! == "" || email.text! == "" || confirmPass.text! == "" || password.text! == "" {
            _ = SweetAlert().showAlert("Error", subTitle: "One or more required fields is empty", style: .error)
        } else {
            //Remember to include birthdate
            let parameters: [String: String] = ["name": fullName, "email": email.text!, "password": password.text!, "birth_date": birthdate, "gender": gender, "school": school.text!, "school_id": schoolID.text!, "counselor_id": counselorID.text!, "grad_year": graduationYear.text!, "phone_number": phoneNumber.text! ]
        
            Service().register(parameters: parameters) { (response) in
                print(response)
                
                //If the user successfully registered popup that it happened
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
    
    @objc func about() {
        _ = SweetAlert().showAlert("About", subTitle: aboutText, style: .none)
    }
}
