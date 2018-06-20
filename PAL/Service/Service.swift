//
//  Service.swift
//  FakeBlog
//
//  Created by Mackensie Alvarez on 5/29/18.
//  Copyright © 2018 Mackensie Alvarez. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Service {
    
    init() {
    }
    
    let baseUrl = "http://pal.njcuacm.org/api"
    let user_id = UserDefaults.standard.value(forKey: "user_id")
    
    //pal.njcuacm.org/api/login
    
    
    //Signup
    func register(parameters: [String: String], callback:@escaping (_ json:JSON) -> ()){
        let url = baseUrl + "/register"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON((json)))
            }
        }
    }
    
    //Login
    func login(parameters: [String: String], callback:@escaping (_ json:JSON) -> ()){
        let url = baseUrl + "/login"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON((json)))
            }
        }
    }
    
    //Get User Profile
    func userProfile(user_id: Int, callback:@escaping (_ json:JSON) -> ()){
        let url = baseUrl + "/profile/\(user_id)"
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON((json)))
            }
        }
    }
    
    //Update User Profile
    func userUpdateProfile(user_id: Int, parameters: [String: String], callback:@escaping (_ json:JSON) ->()) {
        let url = baseUrl + "/profile/update/\(user_id)"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON((json)))
            }
        }
    }
    
    //Get Form By Form ID
    func getFormByID(form_id: Int, callback:@escaping (_ json:JSON) -> ()) {
        let url = baseUrl + "/get/form/index/\(form_id)"
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON(json))
            }
        }
    }
}
