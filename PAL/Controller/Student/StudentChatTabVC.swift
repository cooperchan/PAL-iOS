//
//  StudentChatTabVC.swift
//  PAL
//
//  Created by admin on 7/16/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
 This is the controller for the Chat Tab for the Student
 All it contains is a button that leads to the chat room
*/
class StudentChatTabVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func chatWithCounselorButt(_ sender: Any) {
        self.navigationController?.pushViewController(StudentChatRoomVC(), animated: true)
    }
}
