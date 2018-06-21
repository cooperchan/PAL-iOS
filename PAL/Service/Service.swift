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
    
    //Counselor registers forms, then registers questions for the form, then registers submission to student, student then answers each question -> which is sent to server, then submits form.
    
    
    //Register Form
    func registerForm(parameters: [String: String], callback:@escaping (_ json:JSON) -> ()){
        let url = baseUrl + "/register/form"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON((json)))
            }
        }
    }
    
    //Register Question
    func registerQuestion(form_id: Int, parameters: [String: String], callback:@escaping (_ json:JSON) -> ()){
        let url = baseUrl + "/register/question/\(form_id)"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON((json)))
            }
        }
    }
    
    //Register Submission
    func registerSubmission(user_id: Int, form_id: Int, callback:@escaping (_ json:JSON) ->()) {
        let url = baseUrl + "/register/submission/\(user_id)/\(form_id)"
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON(json))
            }
        }
    }
    
    //Student Answer Question
    func submitAnswer(question_id: Int, submission_id: Int, parameters: [String: String], callback:@escaping (_ json:JSON) -> ()){
        let url = baseUrl + "/submit/question/\(question_id)/\(submission_id)"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if let json = response.result.value {
                callback(JSON((json)))
            }
        }
    }
}
