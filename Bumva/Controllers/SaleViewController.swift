//
//  SaleViewController.swift
//  Bumva
//
//  Created by Максим Белугин on 03.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SaleViewController: UIViewController {

    @IBOutlet weak var typeOfSale: UILabel!
    
    @IBOutlet weak var timeTitle: UILabel!
    
    @IBOutlet weak var mainText: UILabel!
    
    @IBOutlet weak var mainPhoto: UIImageView!
    
    @IBOutlet weak var availabilityTime: UILabel!
    
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var heightOfPhoto: NSLayoutConstraint!
    func loadImage(name: String) {
        
        Alamofire.request("https://www.bumva.com/i/\(name)", method: .get).responseImage { response in
            guard let image = response.result.value else {
                print("error")
                return
            }
            self.mainPhoto.image = image
            self.heightOfPhoto.constant = self.mainPhoto.frame.width*(image.size.height/image.size.width)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = sale?.company.company
        typeOfSale.text = "\(sale!.cat.parentCat)/\(sale!.cat.cat)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        let date = dateFormatter.date(from: sale!.createdDate)
        
        if Date().days(sinceDate: date!) == 0 {
            timeTitle.text = "\(Date().hours(sinceDate: date!) ?? 0) ч. назад"
        }
        else {
            timeTitle.text = "\(Date().days(sinceDate: date!) ?? 0) д. назад"
        }
        
        mainText.text = sale!.description
        if let photo = sale!.photo {
            loadImage(name: photo)
        }
        else {
            heightOfPhoto.constant = 1
            mainPhoto.isHidden = true
        }
        
        if let startDate = dateFormatter.date(from: sale!.startDate ?? "") {
            let day = Calendar.current.component(.day, from: startDate)
            let month = Calendar.current.component(.month, from: startDate)
            if let dueDate = dateFormatter.date(from: sale!.dueDate ?? "") {
                let dueDay = Calendar.current.component(.day, from: dueDate)
                let dueMonth = Calendar.current.component(.month, from: dueDate)
                
                availabilityTime.text = "\(day).\(month) - \(dueDay).\(dueMonth) "
                
            }
            else {
                availabilityTime.text = "..."
            }
        }
        
        else {
            availabilityTime.text = "..."
        }
        
        company.text = sale!.company.company
    }

    var sale: Sale?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCompany" {
            let dest = segue.destination as! CompanyViewController
            dest.company = sale!.company
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
