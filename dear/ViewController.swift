//
//  ViewController.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 10..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit
import DigitsKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupView()
    }
    
    private func setupView() {
        let authButton = DGTAuthenticateButton(authenticationCompletion: { (session, error) in
            if (session != nil) {
                // TODO: associate the session userID with your user model
//                let message = "Phone number: \(session!.phoneNumber)"
//                let alertController = UIAlertController(title: "You are logged in!", message: message, preferredStyle: .Alert)
//                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: .None))
//                self.presentViewController(alertController, animated: true, completion: .None)
                NSLog("Phone number: \(session!.phoneNumber)")
            } else {
                NSLog("Authentication error: %@", error!.localizedDescription)
            }
        })
        authButton?.center = self.view.center
        self.view.addSubview(authButton!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

