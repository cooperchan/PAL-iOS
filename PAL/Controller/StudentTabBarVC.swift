//
//  StudentTabBarVC.swift
//  PAL
//
//  Created by admin on 7/12/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

class StudentTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func logOut() {
        checker = true
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "homepage_nav") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
}
