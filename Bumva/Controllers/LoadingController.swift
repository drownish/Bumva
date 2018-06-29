//
//  LoadingController.swift
//  Bumva
//
//  Created by Максим Белугин on 18.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire

class LoadingController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //var isFirst = true
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        print("appear")
        loadingIndicator.startAnimating()
        if let isLogin = UserDefaults.standard.value(forKey: "isLogin") {
            if isLogin as! Bool {
                let loginStr = UserDefaults.standard.string(forKey: "login")
                let passwordStr = UserDefaults.standard.string(forKey: "password")
                login(login: loginStr!, password: passwordStr!)
            }
            else {
                self.performSegue(withIdentifier: "toLogin", sender: self)
            }
        }
        else {
            self.performSegue(withIdentifier: "toLogin", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*isFirst = true
        print("load")
        loadingIndicator.startAnimating()
        if let isLogin = UserDefaults.standard.value(forKey: "isLogin") {
            if isLogin as! Bool {
                let loginStr = UserDefaults.standard.string(forKey: "login")
                let passwordStr = UserDefaults.standard.string(forKey: "password")
                login(login: loginStr!, password: passwordStr!)
            }
            else {
                self.performSegue(withIdentifier: "toLogin", sender: self)
            }
        }
        else {
            self.performSegue(withIdentifier: "toLogin", sender: self)
        }*/
        
    }

    func login(login: String, password: String) {
        let parameters = [ "email" : login, "password" : password]
        let urlString = "https://www.bumva.com/v1/login"
        let url = URL.init(string: urlString)
        NetworkManager.shared.manager.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            print(response)
            if response.result.isSuccess {
                guard let jsonData = response.result.value as? [String: Any] else {
                    self.performSegue(withIdentifier: "toLogin", sender: self)
                    return
                }
                if jsonData["error"] as! Int != 0 {
                    print("error")
                    self.performSegue(withIdentifier: "toLogin", sender: self)
                }
                else {
                    print("succes")
                    let user = jsonData["user"] as! [String: Any]
                    let name = user["name"] as! String
                    let city = (user["geo"] as! [String: Any])["city"] as! String
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(city, forKey: "city")
                    self.performSegue(withIdentifier: "toContent", sender: self)
                }
                
            }
            else {
                self.performSegue(withIdentifier: "toLogin", sender: self)
                print("hard error")
            }
        }
        
    }

}
