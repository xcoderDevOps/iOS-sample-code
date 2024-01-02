//
//  AddressViewCell.swift
//  UIDevelopment
//
//  Created by MickyBahu on 28/04/19.
//  Copyright © 2019 InfoLabh. All rights reserved.
//

import UIKit

class AddressViewCell: UITableViewCell {
    
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    var blockSlectAddress : ((_ sender : UIButton)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapOnSelectAddress(_ sender: UIButton) {
        if blockSlectAddress != nil {
            blockSlectAddress!(sender)
        }
    }
    
    
}
