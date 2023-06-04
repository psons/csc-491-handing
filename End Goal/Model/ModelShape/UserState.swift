//
//  UserState.swift
//  End Goal
//
//  Created by Paul Sons on 5/20/23.
//

import Foundation

class UserState: Codable, CustomStringConvertible {
    static let uninit = "UNINITIALIZED"
    var userEmail: String = uninit
    var userPassword: String = uninit
    var slotState: SlotState = SlotState()
    var description: String {
        return "{UserState}|userEmail:\(userEmail)|userPassword:?|slotState: \(slotState)|"
    }
    
    init(userEmail: String, userPassword: String, slotState: SlotState = SlotState()) {
        self.userEmail = userEmail
        self.userPassword = userPassword
        self.slotState = slotState
    }
    
    func hasCredentials() -> Bool {
        if userEmail == UserState.uninit {
            return false
        }
        if userPassword == UserState.uninit {
            return false
        }
        return true
    }
    
}
