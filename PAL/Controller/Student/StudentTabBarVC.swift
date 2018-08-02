//
//  StudentTabBarVC.swift
//  PAL
//
//  Created by admin on 7/12/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

/*
 This is the Tab Controller for the Student
 Allows the Log Out Prompt to be on all other View Controllers
 */
class StudentTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Log Out Prompt
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton
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
