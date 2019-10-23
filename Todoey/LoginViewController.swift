//
//  LoginViewController.swift
//  Todoey
//
//  Created by Adrian Kremski on 22/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
    }
}
