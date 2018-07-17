//
//  LoginVC.swift
//  PAL
//
//  Created by admin on 6/11/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //MARK: Variables
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var loginLabel: UILabel!
    var aboutText: String! = "Welcome to PAL. Your Path to Assisted Living! This app is designed as a tol to maintain communication between student and counselor. With PAL, users are able to create profiles, participate in questionnaires and an instant messaging system. The main goal of PAL is to build a orad to fostering emotional well-being. Here at PAL, we hope to improve your life one step at a time."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let rightBarButton = UIBarButtonItem(title: "About", style: UIBarButtonItemStyle.plain, target: self, action: #selector(about))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    @IBAction func login(_ sender: Any) {
        if (emailInput.text?.isEmpty)! || (passwordInput.text?.isEmpty)! {
           _ = SweetAlert().showAlert("Error", subTitle: "Blank text field", style: .error)
        }
        else {
            let parameters: [String: String] = ["email": emailInput.text!, "password": passwordInput.text!]
            Service().login(parameters: parameters) { (response) in
                if response["status"].intValue == 1 {
                    
                    if counter == 0 {
                        _ = SweetAlert().showAlert("Sucess", subTitle: "You are now logged in", style: .success)
                        counter += 1
                    } else {
                        print("How this work")
                    }
                    //Go to main screen and save user ID
                    let user_id = response["message"].intValue
                    
                    //Used to get the role and go to correct Profile page
                    Service().userProfile(user_id: user_id) { (response) in
                        role = response["role"].intValue
                        print("User Role is \(role!)")
                        if role == 0 {
                            //Go to the main screen for students
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "main_student_nav") as! UINavigationController
                            self.present(vc, animated: true, completion: nil)
                        } else if role == 1 {
                            //Go to the main screen for counselor
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "main_counselor_nav") as! UINavigationController
                            self.present(vc, animated: true, completion: nil)
                            
                            
                            //Gets and saves the counselor_id
                            let counselor_id = response["counselor_id"].intValue
                            
                            UserDefaults.standard.set(counselor_id, forKey: "counselor_id")
                            UserDefaults.standard.synchronize()
                            
                        }
                    }
                    print("User ID is: \(user_id)")
                    
                    //Save
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                    UserDefaults.standard.synchronize()

                } else {
                   _ = SweetAlert().showAlert("Error", subTitle: "Email and/or password incorrect", style: .error)
                }
            }
        }
    }
    
    @objc func about() {
        _ = SweetAlert().showAlert("About", subTitle: aboutText, style: .none)
    }
}
