//
//  RegistrationController.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationController: UIViewController, UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("print")
        if string == " " {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin")
    }
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet var popupView: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var popupField: UITextField!
    
    @IBOutlet weak var popupTableView: UITableView!
    
    @IBOutlet weak var popupLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var cityField: UITextField!
    
    var selectedCityId = 0
    
    @objc func textFieldDidChanged() {
        if let txt = popupField.text {
            cities.removeAll()
            
            popupLoadingIndicator.isHidden = false
            popupLoadingIndicator.startAnimating()
            if txt.characters.count > 2 {
            
                findCityByText(txt)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true
        popupField.delegate = self
        popupField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControlEvents.editingChanged)
        popupTableView.delegate = self
        popupTableView.dataSource = self
        shadowView.isHidden = true
        popupView.layer.cornerRadius = 8
        popupView.clipsToBounds = true
        popupLoadingIndicator.isHidden = true
        
        popupTableView.allowsSelection = true
        popupTableView.allowsSelectionDuringEditing = true
        // Do any additional setup after loading the view.
    }

    
    @IBAction func editCityButton(_ sender: Any) {
        
        tapGesture.isEnabled = false
        
        popupView.frame.size.width = self.view.frame.size.width - 50
        popupView.frame.size.height = self.view.frame.size.height - 150
        popupView.center = self.view.center
        shadowView.alpha = 0
        shadowView.isHidden = false
        popupView.alpha = 0
        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 1
            self.shadowView.alpha = 0.65
        })
    }
    
    
    @IBAction func regButton(_ sender: Any) {
        
        colorNormal()
        
        if let fields = checkFields() {
            print("color illegal")
            colorIllegal(fields: fields)
        }
        
        else {
            print("registering, all ok")
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            registerNewUser(name: nameField.text!, email: emailField.text!, password: passwordField.text!, geo: selectedCityId)
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func endTyping(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func registerNewUser(name: String, email: String, password: String, geo: Int) {

        
        let parameters = [ "name" : name, "email" : email, "password" : password, "geo":"\(geo)"]
        let urlString = "https://www.bumva.com/v1/register"
        let url = URL.init(string: urlString)
        NetworkManager.shared.manager.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            print(response)
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            if response.result.isSuccess {
                guard let jsonArray = response.result.value as? [String: Any] else { return }
                print(jsonArray)
                if jsonArray["errcode"] as! Int != 101 {
                    self.showPopup(false)
                } else {
                    self.showPopup(true)
                }
                
            }
            else {
                self.showPopup(false)
            }
        }
    
      

        
    }
    
    func showPopup(_ succes: Bool) {
        var popup = UIAlertController()
        if succes {
            popup = UIAlertController(title: "Успех", message: "Новый пользователь успешно зарегистрирован", preferredStyle: .alert)
            popup.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
        }
        else {
            popup = UIAlertController(title: "Ошибка", message: "Попробуйте заново", preferredStyle: .alert)
            popup.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        }
        self.present(popup, animated: true)
    }
    
    func isValidEmail(testStr: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func checkFields() -> [Int]? {
        var arrayOfIllegal = [Int]()
        
        
        if nameField.text == "" || nameField.text == nil || nameField.text == " " {
            arrayOfIllegal.append(0)
        }
        
        if emailField.text == "" || emailField.text == nil || emailField.text == " " {
            arrayOfIllegal.append(1)
        }
            
        else if !isValidEmail(testStr: emailField.text) {
            if !arrayOfIllegal.contains(1) {
                arrayOfIllegal.append(1)
            }
            
        }
        
        if passwordField.text == "" || passwordField.text == nil || passwordField.text == " " {
            arrayOfIllegal.append(2)
        }
        
        if cityField.text == "" || cityField.text == nil || cityField.text == " " {
            arrayOfIllegal.append(3)
        }
        
        if arrayOfIllegal.isEmpty {
            return nil
        }
        else {
            return arrayOfIllegal
        }
        
    }
    
    func colorIllegal(fields: [Int]) {
        
        for i in fields {
            switch i {
            case 0:
                nameField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                print("nameField color changed")
            case 1:
                emailField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            case 2:
                passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            case 3:
                cityField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            default:
                print("all ok")
            }
        }
        
    }
    
    func colorNormal() {
        nameField.backgroundColor = UIColor.clear
        emailField.backgroundColor = UIColor.clear
        passwordField.backgroundColor = UIColor.clear
        cityField.backgroundColor = UIColor.clear
    }

    var cities = [[String: String]]()
    
    func findCityByText(_ text: String) {
        
        popupLoadingIndicator.isHidden = false
        popupLoadingIndicator.startAnimating()
        print("texxxxt", text.encodeURIComponent()!)
        Alamofire.request("https://www.bumva.com/v1/geo/filter/\(text.encodeURIComponent()!)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            if response.result.isSuccess {
                guard let jsonData = response.result.value as? [[String: Any]] else {
                    print("error")
                    return
                }
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

extension RegistrationController: UITableViewDelegate, UITableViewDataSource {
    
    
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
        let selectedCity = (cities[indexPath.row].first?.value)!
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 0
            self.shadowView.alpha = 0
        })
        cityField.text = selectedCity
        selectedCityId = selectedId
        shadowView.isHidden = true
        popupView.removeFromSuperview()
        tapGesture.isEnabled = true
    }
    
    
    
    
}


















