//
//  MainSalesListController.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire

class MainSalesListController: UITableViewController, reloadHeight {
    
    func reloadHeight() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    

    var allSales = [Sale]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.white
        loadSales(last: 0)
    }

    @IBAction func reloadAction(_ sender: Any) {
        allSales.removeAll()
        tableView.reloadData()
        loadSales(last: 0)
    }
    
    func loadSales(last: Int) {
        let user = UserDefaults.standard.value(forKey: "login") as! String
        let geo = UserDefaults.standard.value(forKey: "geoId") as! String
        let excludedCats = UserDefaults.standard.value(forKey: "excludedCats") as! [Int]
        var formattedArray = (excludedCats.map{String($0)}).joined(separator: ",")
        if excludedCats.count == 0 {
            formattedArray = "0"
        }
        let passwordOld = UserDefaults.standard.value(forKey: "password") as! String
        let credentialData = "\(user):\(passwordOld)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = [
            "Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request("https://www.bumva.com/v1/offers/feed/\(formattedArray)/\(geo)/\(last)", method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { resp in
            if resp.result.isSuccess {
               // print(resp.result.value!)
                guard let jsonResp = resp.result.value as? [String: Any] else {
                    print("error")
                    return
                }
                
                var indexPaths = [Int]()
                
                if !(jsonResp["error"] as! Bool) {
                    let offers = jsonResp["offers"] as! [[String:Any]]
                    var ix = 0
                    for sale in offers {
                        let company = sale["company"] as! [String: Any]
                        let user = sale["user"] as! [String: Any]
                        let userGeo = (sale["user"] as! [String: Any])["geo"] as! [String: Any]
                        let cat = sale["cat"] as! [String: Any]
                        let geo = sale["geo"] as! [String: Any]
                        self.allSales.append(Sale(id: sale["id"] as! String,
                                             company: Company(id: company["id"] as! String,
                                                              company: company["company"] as! String,
                                                              geoId: company["geoId"] as! String,
                                                              city: company["city"] as! String,
                                                              address: company["address"] as! String,
                                                              phone: company["phone"] as! String,
                                                              email: company["email"] as? String,
                                                              site: company["site"] as? String,
                                                              x: company["x"] as! String,
                                                              y: company["y"] as! String,
                                                              time: company["time"] as! String),
                                             user: User(id: user["id"] as! String,
                                                        name: user["name"] as! String,
                                                        email: user["email"] as! String,
                                                        geo: Geo(cId: userGeo["cId"] as! String,
                                                                 rId: userGeo["rId"] as? String,
                                                                 oId: userGeo["oId"] as? String,
                                                                 region: userGeo["region"] as! String,
                                                                 city: userGeo["city"] as! String,
                                                                 rayon: userGeo["rayon"] as? String,
                                                                 id: userGeo["id"] as! String),
                                                        status: user["status"] as! String,
                                                        registerDate: user["registerDate"] as! String),
                                             cat: Cat(id: cat["id"] as! String,
                                                      parentId: cat["parentId"] as! String,
                                                      parentCat: cat["parentCat"] as! String,
                                                      cat: cat["cat"] as! String),
                                             geo: Geo(cId: geo["cId"] as! String,
                                                      rId: geo["rId"] as? String,
                                                      oId: geo["oId"] as? String,
                                                      region: geo["region"] as! String,
                                                      city: geo["city"] as! String,
                                                      rayon: geo["rayon"] as? String,
                                                      id: geo["id"] as! String),
                                             description: sale["description"] as! String,
                                             photo: sale["photo"] as? String,
                                             createdDate: sale["createdDate"] as! String,
                                             startDate: sale["startDate"] as? String,
                                             dueDate: sale["dueDate"] as? String,
                                             status: sale["status"] as! String))
                        
                        indexPaths.append(ix)
                        ix+=1
                    }
                    if self.allSales.count != 0 {
                        var indexs = [IndexPath]()
                        
                        for i in indexPaths {
                            indexs.append(IndexPath(row: last+i, section: 0))
                        }
                        
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: indexs, with: .automatic)
    
                        self.tableView.endUpdates()
                        self.tableView.separatorColor = UIColor.lightGray
                        
                    }
                    else {
                        let alert = UIAlertController(title: "Ошибка", message: "В вашем районе не найдено ни одной акции. Попробуйте сменить местоположение", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        self.tableView.separatorColor = UIColor.white
                    }
                }
                
            }
            else {
                print("hard error")
                print(resp.result.value)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSales.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        let photoCell = tableView.dequeueReusableCell(withIdentifier: "mainCellWithPhoto") as! MainCellWithPhoto
        if let photo = allSales[indexPath.row].photo {
            photoCell.mainTitle.text = allSales[indexPath.row].company.company
            photoCell.mainSubtitle.text = "\(allSales[indexPath.row].cat.parentCat)/\(allSales[indexPath.row].cat.cat)"
            photoCell.mainText.text = allSales[indexPath.row].description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
            let date = dateFormatter.date(from: allSales[indexPath.row].createdDate)
            if Date().days(sinceDate: date!) == 0 {
                photoCell.timeTitle.text = "\(Date().hours(sinceDate: date!) ?? 0) ч. назад"
            }
            else {
                photoCell.timeTitle.text = "\(Date().days(sinceDate: date!) ?? 0) д. назад"
            }
            photoCell.loadImage(name: photo)
            photoCell.delegate = self

            return photoCell
        }
        else {
            cell.mainTitle.text = allSales[indexPath.row].company.company
            cell.mainSubtitle.text = "\(allSales[indexPath.row].cat.parentCat)/\(allSales[indexPath.row].cat.cat)"
            cell.mainText.text = allSales[indexPath.row].description

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
            let date = dateFormatter.date(from: allSales[indexPath.row].createdDate)
            
            if Date().days(sinceDate: date!) == 0 {
                cell.timeTitle.text = "\(Date().hours(sinceDate: date!) ?? 0) ч. назад"
            }
            else {
                cell.timeTitle.text = "\(Date().days(sinceDate: date!) ?? 0) д. назад"
            }
            return cell
        }
        
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == allSales.count-1 && lastRow > 8{
            loadSales(last: lastRow+1)
            print("loadfrom ", lastRow+1)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SaleViewController
        dest.sale = allSales[tableView.indexPathForSelectedRow!.row]
    }
    
    
    
    
    
    
    
    
    

}
