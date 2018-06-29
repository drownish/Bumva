//
//  TabBarController.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(unLogin), name: NSNotification.Name("unLogin"), object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func unLogin() {
        
        navigationController?.popToRootViewController(animated: true)
    }

    

}
