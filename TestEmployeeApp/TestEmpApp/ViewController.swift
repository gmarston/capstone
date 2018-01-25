//
//  ViewController.swift
//  TestEmpApp
//
//  Created by Giselle Marston on 12/5/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit
import AWSSQS
import AWSSNS

var messages = [AWSSQSMessage]()
var indexes = [Int]()
var names = [String]()
var phoneNums = [String]()
var refresher: UIRefreshControl!

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OrderstatusDelegate {
    

    
    @IBOutlet weak var tb: UITableView!
    @IBAction func orderStatusButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString()
        refresher.addTarget(self, action: #selector(ViewController.getAWSMessages), for: UIControlEvents.valueChanged)
        tb?.addSubview(refresher)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPage()
    }
    
    func reloadPage() {
        self.getAWSMessages()
        tb?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        
        cell.orderNum.text = "\(indexes[indexPath.row])" // cast to string
        cell.orderName.text = names[indexPath.row]
        //cell.orderItems.text = "Pizza"
        //cell.takeoutStatus.text = "Dine In"
        cell.delegate = self
        
        return cell
        
    }
    
    func didPressButton(_ sender: UIButton, idx: Int) {
        
        sender.setTitle("Mark Ready", for: .normal)
        sender.backgroundColor = UIColor.green
        
        //var title = sender.currentTitle
        
        if sender.titleLabel?.text == "Mark Ready" {
            self.sendSMS(name: names[idx], phoneNumber: "+1"+phoneNums[idx])
            
            sender.setTitle("Mark Complete", for: .normal)
            sender.backgroundColor = UIColor.blue
        }
        else if sender.titleLabel?.text == "Mark Complete" {
            deleteAWSMessage(idx: idx)
//            names.remove(at: sender.tag)
//            phoneNums.remove(at: sender.tag)
//            indexes.remove(at: indexes.count-1)
//            tb.reloadData()

        }
    }
    
    func sendSMS(name: String, phoneNumber: String){
        
        let smsName = AWSSNSPublishInput()
        smsName?.phoneNumber = phoneNumber
        smsName?.message = "Hi \(name)! Your order is ready to be picked up. Please come " +
            "to the pick-up counter to pay for and receive your food."
        
        let smsSenderID = AWSSNSMessageAttributeValue()

        smsSenderID?.stringValue = "xyz"
        smsSenderID?.dataType = "String"
   
        AWSSNS.default().publish(smsName!).continueWith { (task) -> AnyObject? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                //sent sns
            }
            return nil
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
                                messages = (task.result!.messages)!
                                // loop through all messages
                                print("Success! MESSAGES! ")
                                self.splitAWSList()
    //                            for message in messages {
    //                                print (message.body ?? "FAILURE")
    //                            }
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
        
        tb?.reloadData()
        refresher.endRefreshing()
    }
    
    @objc func deleteAWSMessage(idx: Int){
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
                    
                    let delMsgRequest = AWSSQSDeleteMessageRequest()
                    // Params:
                    delMsgRequest?.queueUrl = queueUrl
                    delMsgRequest?.receiptHandle = messages[idx].receiptHandle
                    
                    let messageDel = messages[idx].body
                    
                    // Delete the message with receipt handler
                    sqs.deleteMessage(delMsgRequest!).continueWith { (task) -> AnyObject! in
                        if let error = task.error {
                            print(error)
                        }
                        
                        if task.result != nil {
                            print("Success! Deleted message with: \(messageDel)")
                        }
                        return nil
                    }
                } else {
                    // No URL found, do something?
                }
            }
            return nil
        }
        
        reloadPage()
    }
    
    
    func splitAWSList() {
        var substrings = [String.SubSequence]()
        var i = 0
        while i < messages.count {
            substrings = (messages[i].body?.split(separator: " "))!
            indexes.insert(i, at: i)
            names.insert(substrings[0] + " " + substrings[1], at: i)
            phoneNums.insert("" + substrings[2], at: i)
            i += 1
        }
    }

}

