//
//  DashboardVC.swift
//  PAL
//
//  Created by admin on 6/13/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func toProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "dashToProfile", sender: nil)
    }
    
    @IBAction func toForms(_ sender: Any) {
         self.performSegue(withIdentifier: "dashToForms", sender: nil)
    }
    
    @IBAction func toTab(_ sender: Any) {
        self.performSegue(withIdentifier: "toTabBar", sender: nil)
    }
    
    
}
