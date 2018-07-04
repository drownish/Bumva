//
//  ProfileController.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire

class ProfileController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var popupField: UITextField!
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var popupLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var shadowView: UIView!
    
    
    
    
    
    
    
    
    @IBOutlet weak var loadingShadow: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    

    @IBOutlet weak var nameTitle: UILabel!
    
    @IBOutlet weak var emailTitle: UILabel!
    
    @IBOutlet weak var cityTitle: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        popupTableView.delegate = self
        popupTableView.dataSource = self
        
        loadingShadow.isHidden = true
        shadowView.isHidden = true
        nameTitle.text = UserDefaults.standard.string(forKey: "name")
        emailTitle.text = UserDefaults.standard.string(forKey: "login")
        cityTitle.text = UserDefaults.standard.string(forKey: "city")
        popupField.delegate = self
        popupField.addTarget(self, action: #selector(fieldDidChanged), for: .editingChanged)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
    
    @objc func fieldDidChanged() {
        guard let text = popupField.text else {
            return
        }
        if text.characters.count > 2 {
            findCityByText(text)
        }
        
    }

    @IBAction func changePassword(_ sender: Any) {
        let alert = UIAlertController(title: "Введите старый пароль", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "password"
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { act in
            let tf = alert.textFields![0]
            guard let newName = tf.text else {
                alert.removeFromParentViewController()
                self.loadingShadow.isHidden = true
                return
            }
            self.loadingShadow.isHidden = false
            self.loadingIndicator.startAnimating()
            if UserDefaults.standard.value(forKey: "password") as! String == newName {
                self.changePasswordPopup()
                print("old password:", newName)
                self.loadingShadow.isHidden = true
            }
            else {
                alert.removeFromParentViewController()
                self.loadingShadow.isHidden = true
                self.showPopupWithText("Пароль неверный")
                return
            }
        }))
        self.present(alert, animated: true)
    }
    
    func changePasswordPopup() {
        
        let alert = UIAlertController(title: "Введите новый пароль", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "password"
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { act in
            let tf = alert.textFields!.last
            guard let newName = tf?.text else {
                alert.removeFromParentViewController()
                self.loadingShadow.isHidden = true
                return
            }
            self.loadingShadow.isHidden = false
            self.loadingIndicator.startAnimating()
            self.changePassword(password: newName)
            print("new passworf from popup:", newName)
        }))
        self.present(alert, animated: true)
        
    }
    
    @IBAction func changeName(_ sender: Any) {
        
        let alert = UIAlertController(title: "Введите новое имя", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "Иван Иванович Иванов"
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { act in
            let tf = alert.textFields![0]
            guard let newName = tf.text else {
                alert.removeFromParentViewController()
                return
            }
            self.loadingShadow.isHidden = false
            self.loadingIndicator.startAnimating()
            self.changeName(newName: newName)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func changeCity(_ sender: Any) {
        popupView.layer.cornerRadius = 8
        popupView.clipsToBounds = true
        popupLoadingIndicator.isHidden = true
        popupView.frame.size.width = self.view.frame.width - 40
        popupView.frame.size.height = self.view.frame.height - 140
        popupView.center = self.view.center
        //popupView.center.y = self.view.center.y - 40
        shadowView.alpha = 0
        shadowView.isHidden = false
        popupView.alpha = 0
        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 1
            self.shadowView.alpha = 0.65
        })
        
    }
    
    
    
    func changePassword(password: String) {
        loadingShadow.isHidden = false
        loadingIndicator.startAnimating()
        let user = UserDefaults.standard.value(forKey: "login") as! String
        let passwordOld = UserDefaults.standard.value(forKey: "password") as! String
        let credentialData = "\(user):\(passwordOld)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = [
            "Authorization": "Basic \(base64Credentials)"]
        
        NetworkManager.shared.manager.request("https://www.bumva.com/v1/users/me/password", method: .post, parameters: ["password" : password], encoding: URLEncoding.httpBody, headers: headers).responseJSON { resp in
            self.loadingShadow.isHidden = true
            if resp.result.isSuccess {
                print(resp.result.value)
                guard let jsonResp = resp.result.value as? [String: Any] else {
                    print("error")
                    self.showPopupWithText("Произошла ошибка")
                    return
                }
                if !(jsonResp["error"] as! Bool) {
                    print("UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATED UPDATE")
                    UserDefaults.standard.set(password, forKey: "password")
                    print("new password:", password)
                    let alert = UIAlertController(title: "Пароль успешно изменен", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { act in
                        UserDefaults.standard.set(false, forKey: "isLogin")
                        NotificationCenter.default.post(name: NSNotification.Name("unLogin"), object: nil)
                    }))
                    self.present(alert, animated: true)
                }
                else {
                    self.showPopupWithText("Произошла ошибка")
                }
            }
            else {
                print("hard error")
                self.showPopupWithText("Произошла ошибка")
            }
        }
    }
    
    func showPopupWithText(_ text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func changeCity(city: String) {
        loadingShadow.isHidden = false
        loadingIndicator.startAnimating()
        let user = UserDefaults.standard.value(forKey: "login") as! String
        let password = UserDefaults.standard.value(forKey: "password") as! String
        let credentialData = "\(user):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = [
            "Authorization": "Basic \(base64Credentials)"]
        let geoId = UserDefaults.standard.value(forKey: "geoId") as! String
        let name = UserDefaults.standard.value(forKey: "name") as! String
        let excCats = UserDefaults.standard.value(forKey: "excludedCats") as! [Int]
        
        NetworkManager.shared.manager.request("https://www.bumva.com/v1/users/me", method: .post, parameters: ["name" : name, "geo": city, "excludedCats" : "\(excCats)"], encoding: URLEncoding.httpBody, headers: headers).validate().responseJSON { resp in
            self.loadingShadow.isHidden = true
            if resp.result.isSuccess {
                print(resp.result.value)
                guard let jsonResp = resp.result.value as? [String: Any] else {
                    print("error")
                    self.showPopupWithText("Произошла ошибка")
                    return
                }
                if !(jsonResp["error"] as! Bool) {
                    
                    UserDefaults.standard.set(city, forKey: "geoId")
                    self.cityTitle.text = ((jsonResp["user"] as! [String: Any])["geo"] as! [String: Any])["city"] as! String
                    self.showPopupWithText("Город успешно изменен")
                }
                else {
                    self.showPopupWithText("Произошла ошибка")
                }
            }
            else {
                print("hard error")
                self.showPopupWithText("Произошла ошибка")
            }
        }
    }
    
    func changeName(newName: String) {
        let user = UserDefaults.standard.value(forKey: "login") as! String
        
        let password = UserDefaults.standard.value(forKey: "password") as! String
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        
        let base64Credentials = credentialData.base64EncodedString()
        
        let headers = [
            "Authorization": "Basic \(base64Credentials)"]
        
        let geoId = UserDefaults.standard.value(forKey: "geoId") as! String
        
        let name = UserDefaults.standard.value(forKey: "name") as! String
        
        guard let excCats = UserDefaults.standard.value(forKey: "excludedCats") as? [Int] else {
            UserDefaults.standard.set([Int](), forKey: "excludedCats")
            changeName(newName: newName)
            return
        }
        
        NetworkManager.shared.manager.request("https://www.bumva.com/v1/users/me", method: .post, parameters: ["name" : newName, "geo": geoId, "excludedCats" : "\(excCats)"], encoding: URLEncoding.httpBody, headers: headers).responseJSON { resp in
            self.loadingShadow.isHidden = true
            if resp.result.isSuccess {
                print(resp.result.value)
                guard let jsonResp = resp.result.value as? [String: Any] else {
                    print("error")
                    self.showPopupWithText("Произошла ошибка")
                    return
                }
                if !(jsonResp["error"] as! Bool) {
                    UserDefaults.standard.set(newName, forKey: "name")
                    self.nameTitle.text = newName
                    self.showPopupWithText("Имя успешно изменено")
                }
                else {
                    self.showPopupWithText("Произошла ошибка")
                }
            }
            else {
                print("hard error")
                self.showPopupWithText("Произошла ошибка")
            }
        }
    }
    
    @IBAction func exitButton(_ sender: Any) {
        let alert = UIAlertController(title: "Выход", message: "Вы уверены что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            UserDefaults.standard.set(false, forKey: "isLogin")
            NotificationCenter.default.post(name: NSNotification.Name("unLogin"), object: nil)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        self.present(alert, animated: true)
       
    }
    
    var cities = [[String: String]]()
    
    var selectedCityId = Int()
    
    func findCityByText(_ text: String) {
        
        popupLoadingIndicator.isHidden = false
        popupLoadingIndicator.startAnimating()
        print("texxxxt", text.encodeURIComponent()!)
        Alamofire.request("https://www.bumva.com/v1/geo/filter/\(text.encodeURIComponent()!)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            print("make resp")
            if response.result.isSuccess {
                guard let jsonData = response.result.value as? [[String: Any]] else {
                    print("error")
                    return
                }
                self.cities.removeAll()
                for i in jsonData {
                    self.cities.append([i["id"] as! String: "\(i["obl"] as! String), \(i["city"] as! String) \(i["rayon"] as? String ?? "")"])
                    
                }
                self.popupLoadingIndicator.isHidden = true
                self.popupTableView.reloadData()
                
            }
            else {
                print(response)
                print("hard error")
            }
        }
    }
    
    
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regCityCell") as! RegCityCell
        cell.title.text = cities[indexPath.row].first?.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("shit")
        
        let selectedId = Int((cities[indexPath.row].first?.key)!)!
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 0
            self.shadowView.alpha = 0
        })
        selectedCityId = selectedId
        changeCity(city: "\(selectedId)")

        shadowView.isHidden = true
        popupView.removeFromSuperview()
    }
    
}




























