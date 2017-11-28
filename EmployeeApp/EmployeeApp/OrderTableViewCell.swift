//
//  OrderTableViewCell.swift
//  EmployeeApp
//
//  Created by Briahna Santillana on 11/27/17.
//  Copyright © 2017 Briahna Santillana. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    //MARK: Properties

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderStatusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
