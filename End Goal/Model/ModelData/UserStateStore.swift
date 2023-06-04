//
//  UserStoreData.swift
//  End Goal
//
//  Created by Paul Sons on 5/20/23.
//

import Foundation

/**
 The go between syncing locally persisted user state with usage by data loaders and views
 Publishes the user state for observers and
 */
class UserStateStore: ObservableObject {
    @Published var userState: UserState
    /**
     todo: build out UserStateStore() in the pattern of StateStore from WYGoal project.
     */
    init() {
        userState = UserState(userEmail: "psons@comcast.net", userPassword: "xxx")
    }
    
    /**
     todo: when implemented this will asynconously load userState from locally persisted store.
        the completion handler should trigger EGEnvironment to figure out if it can load domain data or not
     */
    func load() {
        print("UserStateStore.load() doesn't do anything yet")
    }
}
