//
//  StudentChatTabVC.swift
//  PAL
//
//  Created by admin on 7/16/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

class StudentChatTabVC: UIViewController {

    var availableRooms: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func chatWithCounselorButt(_ sender: Any) {
        Service().findChatRoom(user_id: user_id!) { (response) in
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
               // print("The user_id is: \(user_id!) and the chat_id is: \(chat_id!)")
            
                
                Service().joinChatRoom(user_id: user_id!, chat_id: chat_id!, callback: { (joinResponse) in
                    print("Successfully joined room \(chat_id!)")
                    self.chatWithCounselorButt((Any).self)
                })
            } else if chat_id! > 0 {
                //If the student has or is currently in a room
                print("Successfully joined room \(chat_id!)")
                
                self.performSegue(withIdentifier: "toChatRoom", sender: nil)
                
                
                let params: [String: Any] = ["message": "Message", "chat_id": chat_id!, "student_id": user_id!, "counselor_id": counselor_id!, "role": role!]
                
            }
        }
    }
}
