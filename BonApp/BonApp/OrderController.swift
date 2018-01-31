//
//  OrderController.swift
//  BonApp
//
//  Created by Giselle Marston on 11/1/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit
import AWSSQS


class OrderController: UIViewController {
    
    //carried vars
    var firstName = ""
    var lastName = ""
    var phoneNum = "" //TODO: make type digits

    @IBOutlet weak var cheeseStepOutlet: UIStepper!
    @IBAction func cheeseStepper(_ sender: UIStepper) {
        cheeseCounter.text = String(Int(sender.value))
    }
    @IBOutlet weak var cheeseCounter: UILabel!
    
    @IBOutlet weak var peppStepOutlet: UIStepper!
    @IBAction func peppStepper(_ sender: UIStepper) {
        peppCounter.text = String(Int(sender.value))
    }
    @IBOutlet weak var peppCounter: UILabel!
    
    @IBOutlet weak var specialStepOutlet: UIStepper!
    @IBAction func specialStepper(_ sender: UIStepper) {
        specialCounter.text = String(Int(sender.value))
    }
    @IBOutlet weak var specialCounter: UILabel!
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var okOutlet: UIButton!
    
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBAction func placeOrderButton(_ sender: UIButton) {
        if ( Int(cheeseCounter.text!) != 0 || Int(peppCounter.text!) != 0 || Int(specialCounter.text!) != 0 ) {
            message.isHidden = false
            message.isOpaque = true
            cancelOutlet.isHidden = false
            cancelOutlet.isEnabled = true
            cancelOutlet.isOpaque = true
            okOutlet.isHidden = false
            okOutlet.isEnabled = true
            okOutlet.isOpaque = true
            
            cheeseStepOutlet.isEnabled = false
            peppStepOutlet.isEnabled = false
            specialStepOutlet.isEnabled = false
        }
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        
        //get curr order
        var order = ""
        if (Int(cheeseCounter.text!) != 0){
            order += "(" + String( cheeseCounter.text![(cheeseCounter.text?.startIndex)!] ) + ")Cheese "
        }
        if (Int(peppCounter.text!) != 0){
            order += "(" + String( peppCounter.text![(peppCounter.text?.startIndex)!] ) + ")Pepp "
        }
        if (Int(specialCounter.text!) != 0){
            order += "(" + String( specialCounter.text![(specialCounter.text?.startIndex)!]) + ")Special "
        }
        
        //USE AWS HERE
        let queueName = "BonApp.fifo"
        let sqs = AWSSQS.default()
        
        // Get the queue's URL
        let getQueueUrlRequest = AWSSQSGetQueueUrlRequest()
        getQueueUrlRequest?.queueName = queueName
        sqs.getQueueUrl(getQueueUrlRequest!).continueWith { (task) -> AnyObject! in
            //print("Getting queue URL")
            if let error = task.error {
                print(error)
            }
            
            if task.result != nil {
                if let queueUrl = task.result!.queueUrl {
                    // Got the queue's URL, try to send the message to the queue
                    let sendMsgRequest = AWSSQSSendMessageRequest()
                    sendMsgRequest?.queueUrl = queueUrl
                    sendMsgRequest?.messageGroupId = "MyMessageGroupId1234567890"
                    sendMsgRequest?.messageDeduplicationId = "MyMessageDeduplicationId1234567890"
                    sendMsgRequest?.messageBody = self.firstName + " " + self.lastName + " " + self.phoneNum + " " + order
                    
                    //print(self.firstName + " " + self.lastName + " " + self.phoneNum + " " + order)

                    // Add message attribute if needed
                    let msgAttribute = AWSSQSMessageAttributeValue()
                    msgAttribute?.dataType = "String"
                    msgAttribute?.stringValue = "MY ATTRIBUTE VALUE"
                    sendMsgRequest?.messageAttributes = [:]
                    sendMsgRequest?.messageAttributes!["MY_ATTRIBUTE_NAME"] = msgAttribute
                    
                    // Send the message
                    sqs.sendMessage(sendMsgRequest!).continueWith { (task) -> AnyObject! in
                        if let error = task.error {
                            print(error)
                        }
                        
                        if task.result != nil {
                            print("Success! Check the queue on AWS console!")
                        }
                        return nil
                    }
                } else {
                    // No URL found, do something?
                }
            }
            return nil
        }
    }

    
    @IBAction func cancelButton(_ sender: UIButton) {
        message.isHidden = true
        cancelOutlet.isHidden = true
        cancelOutlet.isEnabled = false
        okOutlet.isHidden = true
        okOutlet.isEnabled = false
        
        cheeseStepOutlet.isEnabled = true
        peppStepOutlet.isEnabled = true
        specialStepOutlet.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        message.isHidden = true
        cancelOutlet.isHidden = true
        cancelOutlet.isEnabled = false
        okOutlet.isHidden = true
        okOutlet.isEnabled = false

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "segue2") {
            let carriedInfo = segue.destination as! ConfirmationController;
            carriedInfo.firstName = firstName
            carriedInfo.lastName = lastName
            carriedInfo.phoneNum = phoneNum //TODO: make type digits
            
            
        }
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
