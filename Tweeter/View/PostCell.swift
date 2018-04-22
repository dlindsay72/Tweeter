//
//  PostCell.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-17.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

public var postCellIdentifier = "postCell"

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameLbl.textColor = customBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


