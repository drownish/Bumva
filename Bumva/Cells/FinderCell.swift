//
//  FinderCell.swift
//  Bumva
//
//  Created by Максим Белугин on 04.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class FinderCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
