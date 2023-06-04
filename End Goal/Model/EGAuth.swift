//
//  EGAuth.swift
//  End Goal
//
//  Created by Paul Sons on 5/20/23.
//

import Foundation
// DISABLING FIRRESTORE
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseAuth

/**
 Has Firebase user management methods and the user data returned
 from login.
 */
// DISABLING FIRRESTORE
//class EGAuth {
//    func loginUser(userEMail: String, userPassword: String) {
//        debugPrint("todo: testing EGAuth.loginUser: \(userEMail) userPassword: \(userPassword)")
//        Auth.auth().signIn(withEmail: userEMail, password: userPassword) { (result, error) in
//           if error != nil {
//               print(error?.localizedDescription ?? "")
//           } else {
//               print("success loging in uid: \(String(describing: result?.user.uid)) ")
//           }
//       }
//   }
//
//    
////    func loginUser() {
////        debugPrint("todo: make separate field or button to login existing: \(userEMail) password: \(password)")
////        Auth.auth().signIn(withEmail: userEMail, password: password) { [weak self] authResult, error in
////          guard let strongSelf = self else { return }
////          // ...
////        }
////    }
//    
//    // https://firebase.google.com/docs/auth/ios/start#sign_up_new_users
//    func signUpUser(userEMail: String, userPassword: String) {
//        debugPrint("signUpUser(): \(userEMail) ")
//        // todo un coment the auth.createUser capability below
////        Auth.auth().createUser(withEmail: userEMail, password: userPassword) { authResult, error in
////            // ...
////            // todo handle the result and error here.
////        }
//    }
//}
