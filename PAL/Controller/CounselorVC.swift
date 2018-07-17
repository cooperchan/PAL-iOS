//
//  CounselorVC.swift
//  PAL
//
//  Created by admin on 6/28/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

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
        
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton

    }

    func getData() {
        Service().userProfile(user_id: user_id!) { (json) in
            self.counselorName.text = "Name: \(json["name"].stringValue)"
            self.counselorEmail.text = "Email: \(json["email"].stringValue)"
            
            let num: String = json["phone_number"].stringValue
            let fixedPhoneNumber = self.getPhoneNumber(num: num)
            self.counselorPhoneNumber.text = "Phone Number: \(fixedPhoneNumber)"
            
            self.counselorBirthday.text = "Birthdate: \(json["birth_date"].stringValue)"
            self.counselorGender.text = "Gender: \(json["gender"].stringValue)"
            self.counselorSchool.text = "School: \(json["school"].stringValue)"
            self.counselorSchoolID.text = "School ID: \(json["school_id"].stringValue)"
            self.CounselorID.text = "Counselor ID: \(json["counselor_id"].stringValue)"
        }
    }
    
    func getPhoneNumber(num: String) -> String {
        let firstThree = num.prefix(3)
        let lastFour = num.suffix(4)
        
        let start = num.index(num.startIndex, offsetBy: 3)
        let end = num.index(num.endIndex, offsetBy: -4)
        let range = start..<end
        
        let midThree = num[range]
        
        return "\(firstThree)-\(midThree)-\(lastFour)"
    }
    
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
    
    @objc func logOut() {
        checker = true
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "homepage_nav") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }

}
