//
//  TimeEstimateController.swift
//  BonApp
//
//  Created by Abhinav Mulagada on 2/28/18.
//  Copyright © 2018 Giselle Marston. All rights reserved.
//

import UIKit

class TimeEstimateController: UIViewController {
    
    var numOrders = 0

    @IBOutlet weak var confirmTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmTextView.isHidden = false
        confirmTextView.text = "Your order has gone through! We estimate that it will be ready for pick-up in \(numOrders*2) minutes. We will also send you a SMS message when it's ready. Thanks!"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
