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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func login(_ sender: Any) {
        if (emailInput.text?.isEmpty)! || (passwordInput.text?.isEmpty)! {
           _ = SweetAlert().showAlert("Error", subTitle: "Blank text field", style: .error)
        }
        else {
            let parameters: [String: String] = ["email": emailInput.text!, "password": passwordInput.text!]
            Service().login(parameters: parameters) { (response) in
                if response["status"].intValue == 1 {
                    
                   _ = SweetAlert().showAlert("Sucess", subTitle: "You are now logged in", style: .success)
                    
                    //Go to main screen and save user ID
                    let user_id = response["message"].intValue
                    print(user_id)
                    
                    
                    //Save
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                    UserDefaults.standard.synchronize()
                    
                    //Go to the main screen
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "main_nav") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                } else {
                   _ = SweetAlert().showAlert("Error", subTitle: "Email and/or password incorrect", style: .error)
                }
            }
        }
    }
    
    

}
