//
//  UsersCell.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-23.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
