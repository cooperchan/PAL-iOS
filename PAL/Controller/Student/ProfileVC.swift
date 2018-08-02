//
//  ProfileVC.swift
//  PAL
//
//  Created by admin on 6/14/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 This is the Profile Page for the Student, the inital page after they login in
 It displays their email, name, phone nmber, birthdate, gender, school, school ID, grad year, and counselor ID
 It contains a button that allows them to go update certain information
 It is part of a tab bar and nav bar, allowing them to switch between Profile, Forms, and Chat
 */
class ProfileVC: UIViewController {

    //MARK: Variables
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var schoolID: UILabel!
    @IBOutlet weak var graduationYear: UILabel!
    @IBOutlet weak var counselorID: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        user_id = UserDefaults.standard.integer(forKey: "user_id")
        getData()
    }
    
    /*
     Get and present all relevant information
    */
    func getData() {
        Service().userProfile(user_id: user_id!) { (json) in
            self.name.text = " \(json["name"].stringValue)"
            self.email.text = " \(json["email"].stringValue)"
           
            let num: String = json["phone_number"].stringValue
            let fixedPhoneNumber = self.getPhoneNumber(num: num)
            self.phoneNumber.text = " \(fixedPhoneNumber)"
            self.birthday.text = " \(json["birth_date"].stringValue)"
            self.gender.text = " \(json["gender"].stringValue)"
            self.school.text = " \(json["school"].stringValue)"
            self.schoolID.text = " \(json["school_id"].stringValue)"
            self.graduationYear.text = " \(json["grad_year"].stringValue)"
            self.counselorID.text = " \(json["counselor_id"].stringValue)"
            
            //Save their User Name
            user_name = json["name"].stringValue
            UserDefaults.standard.set(user_name, forKey: "stud_name")
            UserDefaults.standard.synchronize()
            
            //Save their Counselor ID
            counselor_id = json["counselor_id"].intValue
            UserDefaults.standard.set(counselor_id, forKey: "counselor_id")
            UserDefaults.standard.synchronize()
        }
    }

    /*
    Properly Format the Phone Number
    */
    func getPhoneNumber(num: String) -> String {
        let firstThree = num.prefix(3)
        let lastFour = num.suffix(4)
    
        let start = num.index(num.startIndex, offsetBy: 3)
        let end = num.index(num.endIndex, offsetBy: -4)
        let range = start..<end
        
        let midThree = num[range]
        
        return "\(firstThree)-\(midThree)-\(lastFour)"
    }
    
    /*
     When pressed, gives a popup confirming the move to the UpdateProfile Controller
     Colored using the UIColorFromRGB function
    */
    @IBAction func toUpdateProfile(_ sender: Any) {
        SweetAlert().showAlert("Warning", subTitle: "You are about to change your profile", style: .warning, buttonTitle:"Cancel", buttonColor:UIColorFromRGB(rgbValue: 0xD0D0D0) , otherButtonTitle:  "Proceed", otherButtonColor: UIColorFromRGB(rgbValue: 0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed")
            }
            else {
                self.performSegue(withIdentifier: "profileToUpdate", sender: nil)
            }
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
