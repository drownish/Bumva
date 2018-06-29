//
//  EditCatsCell.swift
//  Bumva
//
//  Created by Максим Белугин on 18.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class EditCatsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
