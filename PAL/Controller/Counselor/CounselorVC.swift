//
//  CounselorVC.swift
//  PAL
//
//  Created by admin on 6/28/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 This is the Profile Page for the Student, the inital page after they login in
 It displays their email, name, phone nmber, birthdate, gender, school, school ID, grad year, and counselor ID
 It contains a button that allows them to go update certain information
*/
class CounselorVC: UIViewController {
    
    //MARK: Variables
    @IBOutlet weak var counselorName: UILabel!
    @IBOutlet weak var counselorEmail: UILabel!
    @IBOutlet weak var counselorPhoneNumber: UILabel!
    @IBOutlet weak var counselorBirthday: UILabel!
    @IBOutlet weak var counselorGender: UILabel!
    @IBOutlet weak var counselorSchool: UILabel!
    @IBOutlet weak var counselorSchoolID: UILabel!
    @IBOutlet weak var CounselorID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        user_id = UserDefaults.standard.integer(forKey: "user_id")
        getData()
        
        //Log Out Prompt
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton

    }

    /*
     Get and present all relevant information
     */
    func getData() {
        Service().userProfile(user_id: user_id!) { (json) in
            self.counselorName.text = " \(json["name"].stringValue)"
            self.counselorEmail.text = " \(json["email"].stringValue)"
            
            let num: String = json["phone_number"].stringValue
            let fixedPhoneNumber = self.getPhoneNumber(num: num)
            self.counselorPhoneNumber.text = " \(fixedPhoneNumber)"
            
            self.counselorBirthday.text = " \(json["birth_date"].stringValue)"
            self.counselorGender.text = " \(json["gender"].stringValue)"
            self.counselorSchool.text = " \(json["school"].stringValue)"
            self.counselorSchoolID.text = " \(json["school_id"].stringValue)"
            self.CounselorID.text = " \(json["counselor_id"].stringValue)"
       
            //Save the username
            user_name = json["name"].stringValue
            UserDefaults.standard.set(user_name, forKey: "stud_name")
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
     When pressed, gives a popup confirming the move to the UpdateCounselorProfile Controller
     Colored using the UIColorFromRGB function
     */
    @IBAction func toUpdateCounselorProfile(_ sender: Any) {
        SweetAlert().showAlert("Warning", subTitle: "You are about to change your profile", style: .warning, buttonTitle:"Cancel", buttonColor:UIColorFromRGB(rgbValue: 0xD0D0D0) , otherButtonTitle:  "Proceed", otherButtonColor: UIColorFromRGB(rgbValue: 0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed")
            }
            else {
                self.performSegue(withIdentifier: "counselorProfileToUpdate", sender: nil)
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
        
        CounselorChatRoomVC.sharedInstance.closeConnection()
    }

}
