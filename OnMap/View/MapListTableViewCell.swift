//
//  MapListTableViewCell.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 04/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit

class MapListTableViewCell: UITableViewCell {

    @IBOutlet weak var usersName: UILabel!
    @IBOutlet weak var postedLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
