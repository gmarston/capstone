//
//  ViewControllerTableViewCell.swift
//  TestEmpApp
//
//  Created by Giselle Marston on 12/5/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit

protocol OrderstatusDelegate : class {
    func didPressButton(_ sender: UIButton, idx: Int)
}

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var orderName: UILabel!
    
    weak var delegate: OrderstatusDelegate?
    
    @IBAction func orderStatusButton(_ sender: UIButton) {
        delegate?.didPressButton(sender,idx: Int(self.orderNum.text!)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
