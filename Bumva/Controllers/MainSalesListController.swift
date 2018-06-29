//
//  MainSalesListController.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class MainSalesListController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
    
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        cell.mainTitle.text = "Гулливер"
        cell.mainSubtitle.text = "Ебать в жопу"
        cell.mainText.text = "Ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу Ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопуЕбать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу ебать в жопу"
        return cell
    }
    

}
