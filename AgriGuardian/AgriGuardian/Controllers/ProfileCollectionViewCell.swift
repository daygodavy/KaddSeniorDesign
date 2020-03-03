//
//  ProfileCollectionViewCell.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 3/1/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var selectedToggle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
