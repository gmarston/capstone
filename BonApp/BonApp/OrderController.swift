//
//  OrderController.swift
//  BonApp
//
//  Created by Giselle Marston on 11/1/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit
import AWSSQS
import DLRadioButton


class OrderController: UIViewController {

    // CONSTANTS:
    var MAX_NUM_ORDERS = 10
    var TIME_INTERVAL_MINUTES = 10

    //carried vars
    var firstName = ""
    var lastName = ""
    var phoneNum = "" //TODO: make type digits

    var toGo = ""
    var messages = [AWSSQSMessage]()
    var numOrdersInQ = 0
    var totalOrderCount = 0

    @IBOutlet weak var dineIn: DLRadioButton!
    @IBOutlet weak var cheeseStepOutlet: UIStepper!
    @IBAction func cheeseStepper(_ sender: UIStepper) {
        cheeseCounter.text = String(Int(sender.value))
    }

    @IBAction func dineInAction(_ sender: DLRadioButton) {
        if sender.tag == 0{
            toGo = "Dine-In"
        }
        else{
            toGo = "To-Go"
        }
        //print(toGo)
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

            self.getAWSMessages()
            self.numOrdersInQ = self.getNumOrders()
            print ("PO num " + String(self.numOrdersInQ))

            message.isHidden = false
            message.isOpaque = true

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
            print("about to print")
            message.text = "They are currently \(self.numOrdersInQ) slices of pizza that were ordered. Are you sure you want to place your order for \(order)\(toGo)? The app will take you to a screen to pay for it."

            cancelOutlet.isHidden = false
            cancelOutlet.isEnabled = true
            cancelOutlet.isOpaque = true
            okOutlet.isHidden = false
            okOutlet.isEnabled = true
            okOutlet.isOpaque = true

            cheeseStepOutlet.isEnabled = false
            peppStepOutlet.isEnabled = false
            specialStepOutlet.isEnabled = false
            
            totalOrderCount = Int(cheeseCounter.text!)! + Int(peppCounter.text!)! + Int(specialCounter.text!)!
            
        }
    }

    @objc func getAWSMessages(){
        //Receiving Orders
        //USING AWS HERE

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

            if task.result != nil {
                if let queueUrl = task.result!.queueUrl {
                    // Got the queue's URL, try to recieve messages from the queue

                    let getMsgsRequest = AWSSQSReceiveMessageRequest()
                    // Params:
                    getMsgsRequest?.queueUrl = queueUrl
                    getMsgsRequest?.attributeNames = ["MY_ATTRIBUTE_NAME"]
                    getMsgsRequest?.maxNumberOfMessages = 10
                    getMsgsRequest?.messageAttributeNames = ["MY_ATTRIBUTE_NAME"]
                    getMsgsRequest?.visibilityTimeout = 15
                    getMsgsRequest?.waitTimeSeconds = 15
                    getMsgsRequest?.receiveRequestAttemptId = "myAttemptId\(Int(arc4random_uniform(1000)))"

                    // Receive the message
                    sqs.receiveMessage(getMsgsRequest!).continueWith { (task) -> AnyObject! in
                        if let error = task.error {
                            print(error)
                        }

                        if task.result != nil {
                            if task.result?.messages != nil{
                                self.messages = (task.result!.messages)!
                                self.numOrdersInQ = self.getNumOrders()
                                print("Success! MESSAGES! ")
                            }
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

    func getNumOrders() -> Int {
        print("Message #: " + String(messages.count))
        var substrings = [String.SubSequence]()
        var orders = [String]()

        var i = 0
        while i < messages.count {
            substrings = (messages[i].body?.split(separator: " "))!

            if substrings.count == 5 {
                orders.insert("" + substrings[4], at: i)
            }
            else if substrings.count == 6 {
                orders.insert(substrings[4] + " " + substrings[5], at: i)
            }
            else if substrings.count == 7 {
                orders.insert(substrings[4] + " " + substrings[5] + " " + substrings[6], at: i)
            }

            i+=1
        }

        var totalOrders = 0
        for item in orders {
            //print(item)
            let number = item.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            for digit in number {
                let strDigit = String(digit)
                if let myInt = Int(strDigit) {
                    totalOrders += myInt
                }
            }
        }
        print("numOrders \(totalOrders)")
        return totalOrders
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

//        //USE AWS HERE
//        let queueName = "BonApp.fifo"
//        let sqs = AWSSQS.default()
//
//        // Get the queue's URL
//        let getQueueUrlRequest = AWSSQSGetQueueUrlRequest()
//        getQueueUrlRequest?.queueName = queueName
//        sqs.getQueueUrl(getQueueUrlRequest!).continueWith { (task) -> AnyObject! in
//            //print("Getting queue URL")
//            if let error = task.error {
//                print(error)
//            }
//
//            if task.result != nil {
//                if let queueUrl = task.result!.queueUrl {
//                    // Got the queue's URL, try to send the message to the queue
//                    let sendMsgRequest = AWSSQSSendMessageRequest()
//                    sendMsgRequest?.queueUrl = queueUrl
//                    sendMsgRequest?.messageGroupId = "MyMessageGroupId1234567890"
//                    sendMsgRequest?.messageDeduplicationId = "MyMessageDeduplicationId1234567890"
//                    sendMsgRequest?.messageBody = self.firstName + " " + self.lastName + " " + self.phoneNum + " " + self.toGo + " " + order
//
//
//                    //print(self.firstName + " " + self.lastName + " " + self.phoneNum + " " + order)
//
//                    // Add message attribute if needed
//                    let msgAttribute = AWSSQSMessageAttributeValue()
//                    msgAttribute?.dataType = "String"
//                    msgAttribute?.stringValue = "MY ATTRIBUTE VALUE"
//                    sendMsgRequest?.messageAttributes = [:]
//                    sendMsgRequest?.messageAttributes!["MY_ATTRIBUTE_NAME"] = msgAttribute
//
//                    // Send the message
//                    sqs.sendMessage(sendMsgRequest!).continueWith { (task) -> AnyObject! in
//                        if let error = task.error {
//                            print(error)
//                        }
//
//                        if task.result != nil {
//                            print("Success! Check the queue on AWS console!")
//                        }
//                        return nil
//                    }
//                } else {
//                    // No URL found, do something?
//                }
//            }
//            return nil
//        }
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
            carriedInfo.totalPrice = Double(totalOrderCount) * 3.50
            carriedInfo.numOrdersInQ = numOrdersInQ
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
