//
//  TripHistoryTableViewCell.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 30/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit

class TripHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var tripId: UILabel!
    @IBOutlet weak var tripStatus: UILabel!
    @IBOutlet weak var tripStatus1: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
