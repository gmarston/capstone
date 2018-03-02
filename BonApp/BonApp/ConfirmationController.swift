//
//  ConfirmationController.swift
//  BonApp
//
//  Created by Giselle Marston on 9/29/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//


// order -> confirmation -> apple pay -> queue

import UIKit
import PassKit
import AWSSQS

class ConfirmationController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    //carried vars
    var firstName = ""
    var lastName = ""
    var phoneNum = "" //TODO: make type digits
    var totalPrice = 0.00
    var numOrdersInQ = 0
    var paymentSucceeded = false
    var theOrder = ""
    var numSlices = 0
    var numOrders = 0
    
    @IBOutlet weak var toPayTextView: UITextView!
    
    @IBAction func sendOrderButton(_ sender: UIButton) {
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
                    sendMsgRequest?.messageBody = self.firstName + " " + self.lastName + " " + self.phoneNum + " " + self.theOrder


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
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem])->Void ) {
        completion(PKPaymentAuthorizationStatus.success, itemToSell(shipping: 0.00))
    }

    private var merchantId = "merchant.edu.up.marston18.BonAppDeveloper"
    
    
    @IBOutlet weak var payButton: PKPaymentButton!
    var paymentRequest: PKPaymentRequest!
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func itemToSell(shipping: Float) -> [PKPaymentSummaryItem]{
        // use totalPrice
        let orderTotal = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: totalPrice))
        return [orderTotal]
    }
    
    @IBAction func payAction(_ sender: Any) {
        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .masterCard, .discover]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks){
            paymentRequest = PKPaymentRequest()
            paymentRequest.currencyCode = "USD"
            paymentRequest.countryCode = "US"
            paymentRequest.merchantIdentifier = "merchant.edu.up.marston18.BonAppDeveloper"
            paymentRequest.supportedNetworks = paymentNetworks
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.paymentSummaryItems = self.itemToSell(shipping: 0.00)
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            applePayVC?.delegate = self
            self.present(applePayVC!, animated: true, completion: nil)
        }
        else{
            print("Please set up Apple Pay")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toPayTextView.isHidden = false
        print("numOrdersInQ in C: \(numOrdersInQ)")
        if (numOrdersInQ > 15){ // TOO MANY ORDERS IN QUEUE --> DON'T LET ORDER GO THROUGH
            payButton.isEnabled = false
            payButton.isHidden = true
            toPayTextView.text = "Hi, \(firstName) \(lastName)! There are currently \(numOrdersInQ) slices to be picked up so we cannot take your order. Please try again later."
            
        }
        else{
            toPayTextView.text = "Hi, \(firstName) \(lastName)! Please continue paying for \(theOrder)."
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "segue3") {
            let carriedInfo = segue.destination as! TimeEstimateController;
            print("CC: \(numSlices + numOrdersInQ)")
            carriedInfo.numOrders = numSlices + numOrdersInQ
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
