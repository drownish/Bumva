//
//  MainCellWithPhoto.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class MainCellWithPhoto: UITableViewCell {

    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var mainSubtitle: UILabel!
    
    @IBOutlet weak var timeTitle: UILabel!
    
    @IBOutlet weak var mainText: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.setSelected(false, animated: true)
    }

}
