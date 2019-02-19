//
//  LTVC_TableViewCell.swift
//  NunezJonathan_CE07
//
//  Created by Jonathan Nunez on 12/6/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import UIKit

class LTVC_TableViewCell: UITableViewCell {
    
    // MARK: Preparations
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
