//
//  ViewController.swift
//  PAL
//
//  Created by Mackensie Alvarez on 6/10/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var logo: UIImageView!
    var aboutText: String! = "Welcome to PAL. Your Path to Assisted Living! This app is designed as a tool to maintain communication between student and counselor. With PAL, users are able to create profiles, participate in questionnaires and an instant messaging system. The main goal of PAL is to build a road to fostering emotional well-being. Here at PAL, we hope to improve your life one step at a time."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Add right bar button
        let rightBarButton = UIBarButtonItem(title: "About", style: UIBarButtonItemStyle.plain, target: self, action: #selector(about))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //If first time on app, display About Information
        if counter == 0 {
            _ = SweetAlert().showAlert("About", subTitle: aboutText, style: .none)
            counter += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(checker) {
            _ = SweetAlert().showAlert("Success", subTitle: "You have logged out!", style: .success)
            checker = false
        } else {
            print("The checker is currently false")
        }
    }
    
    @objc func about() {
       _ = SweetAlert().showAlert("About", subTitle: aboutText, style: .none)
    }
}

