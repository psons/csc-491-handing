//
//  EGEnv.swift
//  End Goal
//
//  Created by Paul Sons on 5/20/23.
//

import Foundation

class EGEnvironment: ObservableObject {
//    @Published var dStore: DomainStore = DomainStore()
    @Published var uStore: UserStateStore = UserStateStore()
    // DISABLING FIRRESTORE
//    @Published var auth: EGAuth = EGAuth()


    init() {
        print("EGEnvironment.init()")
//        self.dStore = DominStore()
    }
    
    /**
     uStore.load()
     observe the uSate, and when it hasCredentials dStore.load()
        See Content view for observance of dStore()
     */
    
    func loadEnvironment() {
        print("EGEnvironment.loadEnvironment()")
        uStore.load() /*
                       this should be async and on completion cause dStore to load
                       (if the uStore has a saved e-mail and password)
                       */
        // DISABLING FIRRESTORE
//        if uStore.userState.hasCredentials() {
//            auth.loginUser(userEMail: uStore.userState.userEmail, userPassword: uStore.userState.userPassword)
//                /*
//                    this should also be async, and if it works, should dStor.load()
//                   */
////            dStore.load() /*{
////                _ in
////                print("match the Result with a case and decode the Domain")
////            } */
//        }
    }
    
}


///*
// https://stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime
// let date = Date()
// let calendar = Calendar.current
// let hour = calendar.component(.hour, from: date)
// let minutes = calendar.component(.minute, from: date)
// */
//func myFormattedDate(dString: String) -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//    let dateTime = dateFormatter.date(from: dString)
//    if let dtString = dateTime?.formatted() {
//        return dtString
//    }
//    return "Unrecognized date format"
//}
