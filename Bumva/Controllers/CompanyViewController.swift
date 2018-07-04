//
//  CompanyViewController.swift
//  Bumva
//
//  Created by Максим Белугин on 04.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController {

    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = company!.company
        address.text = "\(company!.city), \(company!.address)"
        phone.text = company!.phone
        email.text = company!.email ?? "..."
        site.text = company!.site ?? "..."
        time.text = company!.time
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var site: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! MapViewController
        dest.company = company
    }

}
