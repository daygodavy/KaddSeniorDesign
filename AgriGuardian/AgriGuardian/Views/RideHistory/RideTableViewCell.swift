//
//  RideTableViewCell.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/1/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
