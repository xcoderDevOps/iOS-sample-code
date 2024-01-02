//
//  DropDownCustomCell.swift
//  CargoXpress
//
//  Created by infolabh on 19/07/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import DropDown

class DropDownCustomCell: DropDownCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
