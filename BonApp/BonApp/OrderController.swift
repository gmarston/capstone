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
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var okOutlet: UIButton!
    
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBAction func placeOrderButton(_ sender: UIButton) {
        message.isHidden = false
        cancelOutlet.isHidden = false
        cancelOutlet.isEnabled = true
        okOutlet.isHidden = false
        okOutlet.isEnabled = true
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        //TODO: ORDER GOES THROUGH
        //USE AWS HERE
        
        let queueName = "BonApp.fifo"
        let sqs = AWSSQS.default()
        
        // Get the queue's URL
        let getQueueUrlRequest = AWSSQSGetQueueUrlRequest()
        getQueueUrlRequest?.queueName = queueName
        sqs.getQueueUrl(getQueueUrlRequest!).continueWith { (task) -> AnyObject! in
            print("Getting queue URL")
            if let error = task.error {
                print(error)
            }
            if let exception = task.error{
                print(exception)
            }
            
            if task.result != nil {
                if let queueUrl = task.result!.queueUrl {
                    // Got the queue's URL, try to send the message to the queue
                    let sendMsgRequest = AWSSQSSendMessageRequest()
                    sendMsgRequest?.queueUrl = queueUrl
                    sendMsgRequest?.messageGroupId = "MyMessageGroupId1234567890"
                    sendMsgRequest?.messageDeduplicationId = "MyMessageDeduplicationId1234567890"
                    sendMsgRequest?.messageBody = self.firstName + " " + self.lastName + " " + self.phoneNum
                    
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
                        if let exception = task.error {
                            print(exception)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //orderLabel.text = firstName
        
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
