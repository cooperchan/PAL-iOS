//
//  CounselorActivitiesVC.swift
//  PAL
//
//  Created by admin on 7/19/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

class CounselorActivitiesVC: UIViewController {

    var availableRooms: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func toAssignFormsButt(_ sender: Any) {
        
    }
    
    
    @IBAction func toChatButt(_ sender: Any) {
        
        let studID = UserDefaults.standard.integer(forKey: "student_id")
        print(studID)
        
        Service().findChatRoom(user_id: studID) { (response) in
            //Loop through all chat rooms with student and puts them in the last one
            for(_, responseJSON):(String, JSON) in response {
                chat_id = responseJSON["id"].intValue
            }
            
            if chat_id! == 0 {
                //If the student hasn't been in a room
                Service().knockChatRoom(callback: { (knockResponse) in
                    //Loop through the available rooms and get their chat_ids, store in an array
                    for(_, responseJSON):(String, JSON) in knockResponse {
                        let openRoomID = responseJSON["message"].intValue
                        self.availableRooms.append(openRoomID)
                        
                        //Get the first available chat room id and save it
                        chat_id = self.availableRooms[0]
                        UserDefaults.standard.set(chat_id, forKey: "chat_id")
                        UserDefaults.standard.synchronize()
                    }
                })
                
                chat_id = UserDefaults.standard.integer(forKey: "chat_id")
                
                Service().joinChatRoom(user_id: user_id!, chat_id: chat_id!, callback: { (joinResponse) in
                    print("Successfully joined room \(chat_id!)")
                    self.toChatButt((Any).self)
                })
            } else if chat_id! > 0 {
                //If the student has or is currently in a room
                _ = SweetAlert().showAlert("Success", subTitle: "You are now in Room \(chat_id!)", style: .success)
                
                //self.performSegue(withIdentifier: "toChatRoom", sender: nil)
                self.navigationController?.pushViewController(CounselorChatRoomVC(), animated: true)
                
            }
        }
    }
}
