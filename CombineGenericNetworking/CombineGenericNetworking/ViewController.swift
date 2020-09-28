//
//  ViewController.swift
//  CombineGenericNetworking
//
//  Created by Gagan  Vishal on 9/27/20.
//

import UIKit
import Combine
class ViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //AnyCancellable for Combine and memory management
    var cancellable: AnyCancellable?
    //MARK:- View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- Get Request
    @IBAction func getDataFromServer(_ sender: Any) {
        self.activityIndicator(startAnimating: true)
        self.cancellable = Networking.makeRequest(for: EndPoint.featuredItems, using:  nil, method: .get).sink(receiveCompletion: {print($0)}) { (model) in
            self.activityIndicator(startAnimating: false)
            print(model as Any)
        }
    }
    
    deinit {
        self.cancellable = nil
    }

    //MARK:- Post Request
    @IBAction func makePostRequest(_ sender: Any) {
        self.activityIndicator(startAnimating: true)
        self.cancellable = Networking.makeRequest(for: EndPoint.addNewUser(), using: nil, method: .post).sink(receiveCompletion: {print($0)}) { (model) in
            self.activityIndicator(startAnimating: false)
            print(model as Any)
        }
    }
    
    
    //MARK:- PUT
    @IBAction func makePutRequest(_ sender: Any) {
        //Please chage values here
        let dic = ["name": "morpheus", "job": "zion resident", "updatedAt":"2020-09-27T19:17:44.804Z"]
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            self.activityIndicator(startAnimating: true)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                self.cancellable = Networking.makeRequest(for: EndPoint<FormedRequestKind.Public, Dictionary<String, String>>(path: "/api/users/2", data: jsonString.data(using: .utf8)!), using: nil, method: .put).sink(receiveCompletion: {print($0)}) { (model) in
                    print(model as Any)
                    self.activityIndicator(startAnimating: false)
                }
            }
        }
    }
    
    //MARK:- Delete
    @IBAction func deleteRequest(_ sender: Any) {
        self.activityIndicator(startAnimating: true)
        self.cancellable = Networking.makeRequest(for: EndPoint<FormedRequestKind.Public, Bool>(path: "/api/users/2",  data: nil), using: nil, method: .delete).sink(receiveCompletion: {print($0)}) { (response) in
            print(response as Any)
            self.activityIndicator(startAnimating: false)

        }
    }
    
    //MARK:- Activity indicator handling
    fileprivate func activityIndicator(startAnimating: Bool) {
        startAnimating ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    }

}

