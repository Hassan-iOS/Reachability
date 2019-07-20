//
//  ViewController.swift
//  Reachability-Demo
//
//  Created by Hassan Mostafa on 7/20/19.
//  Copyright © 2019 Minds. All rights reserved.
//

import UIKit
import SwiftMessages

class ViewController: UIViewController {

    let reachability = Reachability()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try reachability?.startNotifier()
        } catch let error {
            print(error)
        }
        handleReachability()
    }
    fileprivate func handleReachability() {
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: reachability, queue: .main) { (notification) in
            if let MyRechability = notification.object as? Reachability {
                switch MyRechability.connection {
                case .cellular:
                    self.displayMessage(message: "Connected by cellular data", messageError: false)
                case .wifi:
                    self.displayMessage(message: "Connected by Wifi", messageError: false)
                case .none:
                    self.displayMessage(message: "No Internet Connection", messageError: true)
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    func displayMessage(message: String, messageError: Bool) {
        
        let view = MessageView.viewFromNib(layout: MessageView.Layout.messageView)
        if messageError == true {
            view.configureTheme(.error)
        } else {
            view.configureTheme(.success)
        }
        
        view.iconImageView?.isHidden = true
        view.iconLabel?.isHidden = true
        view.titleLabel?.isHidden = true
        view.bodyLabel?.text = message
        view.titleLabel?.textColor = UIColor.white
        view.bodyLabel?.textColor = UIColor.white
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        SwiftMessages.show(config: config, view: view)
    }
}
