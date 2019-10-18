//
//  FindARideTableViewCell.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 30/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit

class FindARideTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
