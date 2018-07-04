//
//  MainCellWithPhoto.swift
//  Bumva
//
//  Created by Максим Белугин on 11.06.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol reloadHeight {
    func reloadHeight()
}

class MainCellWithPhoto: UITableViewCell {

    var delegate: reloadHeight?
    
    @IBOutlet weak var heightPhoto: NSLayoutConstraint!
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

        //self.setSelected(false, animated: true)
    }

    func loadImage(name: String) {
        
        Alamofire.request("https://www.bumva.com/i/\(name)", method: .get).responseImage { response in
            guard let image = response.result.value else {
                    print("error")
                    return
            }
            self.mainImage.image = image
            //self.heightPhoto.constant = self.mainImage.frame.width*(image.size.height/image.size.width)
           //self.delegate?.reloadHeight()
        }
    }
    
}
