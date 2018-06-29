//
//  LoginController.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire

class LoginController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    

    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true
       
        // Do any additional setup after loading the view.
    }

    @IBAction func endTyping(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        colorNormal()
        if let invalidFields = validateFields() {
            colorInvalid(invalidFields)
        }
        else {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            login(login: loginField.text!, password: passwordField.text!)
        }
        
    }
    
    func colorNormal() {
        loginField.backgroundColor = UIColor.white
        passwordField.backgroundColor = UIColor.white
    }
    
    func colorInvalid(_ arr: [Int]) {
        for i in arr {
            switch i {
            case 1:
                loginField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                
            default:
                passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            }
        }
    }
    
    func validateFields() -> [Int]? {
        var arrayOfInvalid = [Int]()
        if loginField.text == nil || loginField.text == "" || loginField.text == " " {
            arrayOfInvalid.append(1)
        }
        if passwordField.text == nil || passwordField.text == "" || passwordField.text == " " {
            arrayOfInvalid.append(2)
        }
        if arrayOfInvalid.isEmpty {
            return nil
        }
        else {
            return arrayOfInvalid
        }
    }
    
    
    func showPopup() {
        var popup = UIAlertController()
        
        popup = UIAlertController(title: "Ошибка", message: "Логин или пароль введены неверно", preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        
        self.present(popup, animated: true)
        loginField.text = nil
        passwordField.text = nil
    }
    
    func login(login: String, password: String) {
        let parameters = [ "email" : login, "password" : password]
        let urlString = "https://www.bumva.com/v1/login"
        let url = URL.init(string: urlString)
        NetworkManager.shared.manager.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            print(response)
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            if response.result.isSuccess {
                guard let jsonData = response.result.value as? [String: Any] else {return}
                if jsonData["error"] as! Int != 0 {
                    print("error")
                    self.showPopup()
                }
                else {
                    print("succes")
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    UserDefaults.standard.set(login, forKey: "login")
                    UserDefaults.standard.set(password, forKey: "password")
                    print("login and password set")
                    let user = jsonData["user"] as! [String: Any]
                    let name = user["name"] as! String
                    let city = (user["geo"] as! [String:Any])["city"] as! String
                    let geoId = (user["geo"] as! [String:Any])["id"] as! String
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(city, forKey: "city")
                    UserDefaults.standard.set(geoId, forKey: "geoId")
                    self.performSegue(withIdentifier: "login", sender: self)
                }
                
            }
            else {
                self.showPopup()
                print("hard error")
            }
        }
        
    }
    
}
