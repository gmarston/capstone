//
//  ViewControllerTableViewCell.swift
//  TestEmpApp
//
//  Created by Giselle Marston on 12/5/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var orderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
