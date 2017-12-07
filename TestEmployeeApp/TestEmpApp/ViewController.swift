//
//  ViewController.swift
//  TestEmpApp
//
//  Created by Giselle Marston on 12/5/17.
//  Copyright © 2017 Giselle Marston. All rights reserved.
//

import UIKit
import AWSSQS

var messages = [AWSSQSMessage]()
var indexes = [Int]()
var names = [String]()
var phoneNums = [String]()
var refresher: UIRefreshControl!

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tb: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString()
        refresher.addTarget(self, action: #selector(ViewController.getAWSMessages), for: UIControlEvents.valueChanged)
        tb?.addSubview(refresher)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAWSMessages()
        tb?.reloadData()
        print("\n\n\nEND OF viewWillAppear METHOD\n\n\n")
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
        
        return cell
        
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
                        if let exception = task.error {
                            print(exception)
                        }
                        
                        if task.result != nil {
                            messages = (task.result?.messages)!
                            // loop through all messages
                            print("Success! MESSAGES! ")
                            self.splitAWSList()
                            for message in messages {
                                print (message.body ?? "FAILURE")
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
