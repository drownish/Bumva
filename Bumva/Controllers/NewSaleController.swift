//
//  NewSaleController.swift
//  Bumva
//
//  Created by Максим Белугин on 04.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire

class NewSaleController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var foundCompanies = [Company]()
    var foundCategories = [Cat]()
    
    var stateOfPopup = 0
    
    var selectedCompany: Company?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.isHidden = true
        finderTableView.delegate = self
        finderTableView.dataSource = self
        finderField.addTarget(self, action: #selector(fieldDidChanged), for: .editingChanged)
        finderTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    
    
    
    
    
    
    @IBOutlet var finderPopup: UIView!
    @IBOutlet weak var finderTitle: UILabel!
    @IBOutlet weak var finderField: UITextField!
    @IBOutlet weak var finderTableView: UITableView!
    @IBOutlet weak var finderLoadincIndicator: UIActivityIndicatorView!
    
    @IBAction func endType(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func showPopupOf(type: Int) {
        finderLoadincIndicator.isHidden = true
        tapGesture.isEnabled = false
        shadowView.alpha = 0
        shadowView.isHidden = false
        finderPopup.frame.size.width = shadowView.frame.width - 40
        finderPopup.frame.size.height = UIScreen.main.bounds.height - self.tabBarController!.tabBar.frame.height - (UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height) - 40
        finderPopup.center = self.view.center
        finderPopup.layer.cornerRadius = 8
        finderPopup.clipsToBounds = true
        finderPopup.alpha = 0
        self.view.addSubview(finderPopup)
        UIView.animate(withDuration: 0.2, animations: {
            self.shadowView.alpha = 0.65
            self.finderPopup.alpha = 1
        })
    }
    
    func removeMainPopup() {
        tapGesture.isEnabled = true
        UIView.animate(withDuration: 0.2, animations: {
            self.shadowView.alpha = 0
            self.finderPopup.alpha = 0
        }, completion: { _ in
            self.shadowView.isHidden = true
            self.finderPopup.removeFromSuperview()
        })
    }
    
    @objc func fieldDidChanged() {
        if stateOfPopup == 0, let text = finderField.text {
            if text.characters.count > 2 {
                findCompanyByText(text)
            }
        }
    }
    
    func findCompanyByText(_ text: String) {
        self.finderLoadincIndicator.isHidden = false
        self.finderLoadincIndicator.startAnimating()
        
        let user = UserDefaults.standard.value(forKey: "login") as! String
        let passwordOld = UserDefaults.standard.value(forKey: "password") as! String
        let credentialData = "\(user):\(passwordOld)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = [
            "Authorization": "Basic \(base64Credentials)"]
        
        print("texxxxt", text.encodeURIComponent()!)
        Alamofire.request("https://www.bumva.com/v1/companies/search/\(text.encodeURIComponent()!)", method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                guard let jsonData = response.result.value as? [String: Any] else {
                    print("error")
                    return
                }
                let companies = jsonData["companies"] as! [[String:Any]]
                self.foundCompanies.removeAll()
                for company in companies {
                    self.foundCompanies.append(Company(id: company["id"] as! String,
                                                       company: company["company"] as! String,
                                                       geoId: company["geoId"] as! String,
                                                       city: company["city"] as! String,
                                                       address: company["address"] as! String,
                                                       phone: company["phone"] as! String,
                                                       email: company["email"] as? String,
                                                       site: company["site"] as? String,
                                                       x: company["x"] as! String,
                                                       y: company["y"] as! String,
                                                       time: company["time"] as! String))
                    
                }
                self.finderLoadincIndicator.isHidden = true
                self.finderTableView.reloadData()
                
            }
            else {
                print(response)
                print("hard error")
            }
        }
    }
    
    @IBOutlet weak var company: UITextField!
    @IBAction func editCompany(_ sender: Any) {
        stateOfPopup = 0
        showPopupOf(type: stateOfPopup)
    }
    
    @IBOutlet weak var category: UITextField!
    @IBAction func editCategory(_ sender: Any) {
    }
    
    @IBOutlet weak var descript: UITextView!
    
    @IBOutlet weak var startDate: UITextField!
    @IBAction func editStartDate(_ sender: Any) {
    }
    
    @IBOutlet weak var dueDate: UITextField!
    @IBAction func editDueDate(_ sender: Any) {
    }
    
    
    @IBOutlet weak var photo: UIImageView!
    @IBAction func editPhoto(_ sender: Any) {
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
    }
    
    
    
    
}

extension NewSaleController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stateOfPopup == 0 {
            return foundCompanies.count
        }
        else {
            return foundCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regCityCell") as! FinderCell
        if stateOfPopup == 0 {
            cell.title.text = foundCompanies[indexPath.row].company
            cell.subtitle.text = foundCompanies[indexPath.row].address
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if stateOfPopup == 0 {
            selectedCompany = foundCompanies[indexPath.row]
            company.text = selectedCompany!.company
            removeMainPopup()
        }
    }
    
    
    
    
}




















