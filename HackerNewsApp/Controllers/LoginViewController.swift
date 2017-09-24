//
//  LoginViewController.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 23/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Spring

class LoginViewController: BaseViewController {

    @IBOutlet fileprivate weak var signInButtonSpringView: SpringView! {
        didSet {
            signInButtonSpringView.isHidden = true
        }
    }

    @IBOutlet fileprivate weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.signInButtonSpringView.isHidden = true
                self.performSegue(withIdentifier: "Show Main App", sender: nil)
            } else {
                self.signInButtonSpringView.isHidden = false
                self.signInButtonSpringView.animate()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.signInButton.isEnabled = true
            })
        }
    }

    @IBAction func googleSignInTapped(sender: AnyObject) {
        signInButton.isEnabled = false
    }

}

extension LoginViewController: GIDSignInUIDelegate {
}
