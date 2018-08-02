//
//  CounselorActivitiesVC.swift
//  PAL
//
//  Created by admin on 7/19/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 This is the controller for the Chat Tab for the Counselor
 All it contains is 2 buttons
 A button that leads to Assign Forms
 A button that leads to the chat room
 */
class CounselorActivitiesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Log Out Prompt
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    @IBAction func toAssignFormsButt(_ sender: Any) {
        
    }
    
    
    @IBAction func toChatButt(_ sender: Any) {
        self.navigationController?.pushViewController(CounselorChatRoomVC(), animated: true)
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
