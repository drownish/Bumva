//
//  EditCatsController.swift
//  Bumva
//
//  Created by Максим Белугин on 18.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire

class Categ {
    var id: String
    var parentId: String
    var parentCat: String
    var cat: String
    var isSelected: Bool
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as! String
        self.parentId = dict["parentId"] as! String
        self.parentCat = dict["parentCat"] as! String
        self.cat = dict["cat"] as! String
        self.isSelected = false
    }
}

class EditCatsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        loadingIndicator.startAnimating()
        loadCatsFromServer()
        // Do any additional setup after loading the view.
    }
    
    var catsArray = [Categ]()

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func saveButton(_ sender: Any) {
        var arrayOfSelected = [Int]()
        for i in catsArray {
            if i.isSelected {
                arrayOfSelected.append(Int(i.id)!)
            }
        }
        UserDefaults.standard.set(arrayOfSelected, forKey: "excludedCats")
        navigationController?.popToRootViewController(animated: true)
        uploadCatsToServer(cats: arrayOfSelected)
    }
    
    func loadCats(arr: [[String: Any]]) -> [Categ] {
        var arrToReturn = [Categ]()
        for dict in arr {
            arrToReturn.append(Categ(dict: dict))
        }
        guard let excludedCats = UserDefaults.standard.value(forKey: "excludedCats") as? [Int] else {
            return arrToReturn
        }
        for i in arrToReturn {
            if excludedCats.contains(Int(i.id)!) {
                i.isSelected = true
            }
        }
        return arrToReturn
    }
    
    
    func uploadCatsToServer(cats: [Int]) {
        
        let user = UserDefaults.standard.value(forKey: "login") as! String
        
        let password = UserDefaults.standard.value(forKey: "password") as! String
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        
        let base64Credentials = credentialData.base64EncodedString()
        
        print("easy shtuka \(cats)")
        
        let headers = [
            "Authorization": "Basic \(base64Credentials)"]
        
        let geoId = UserDefaults.standard.value(forKey: "geoId") as! String
        
        let name = UserDefaults.standard.value(forKey: "name") as! String
        
        NetworkManager.shared.manager.request("https://www.bumva.com/v1/users/me", method: .post, parameters: ["name" : name, "geo": geoId, "excludedCats" : "\(cats)"], encoding: URLEncoding.httpBody, headers: headers).responseJSON { resp in
            if resp.result.isSuccess {
                print(resp.result.value)
            }
            else {
                print("hard error")
            }
        }
    }
    
    
    func loadCatsFromServer() {
        NetworkManager.shared.manager.request("https://www.bumva.com/v1/categories", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            if response.result.isSuccess {
                if let resp = response.result.value as? [String: Any] {
                    if !(resp["error"] as! Bool) {
                        self.catsArray = self.loadCats(arr: resp["categories"] as! [[String: Any]])
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                        self.tableView.isHidden = false
                        
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("error")
                return
            }
        }
    }
    
}

extension EditCatsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCatsCell") as! EditCatsCell
        cell.title.text = catsArray[indexPath.row].parentCat
        cell.subtitle.text = catsArray[indexPath.row].cat
        if catsArray[indexPath.row].isSelected {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellType = tableView.cellForRow(at: indexPath)?.accessoryType {
            if cellType == .none {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
                catsArray[indexPath.row].isSelected = true
            }
            else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                catsArray[indexPath.row].isSelected = false
            }
        }
    }
    
    
    
    
}
