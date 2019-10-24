//
//  FirebaseAuthManager.swift
//  Todoey
//
//  Created by Adrian Kremski on 23/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    func logout(block: (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            block(nil)
        } catch {
            block(error)
            print(error)
        }
    }
    
    func isLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
}
