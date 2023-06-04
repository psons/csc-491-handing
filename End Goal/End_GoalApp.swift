//
//  End_GoalApp.swift
//  End Goal
//
//  Created by Paul Sons on 5/17/23.
//

import SwiftUI
// DISABLING FIRRESTORE
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseAuth
//import FirebaseMessaging // THIS IS FOR the Swizzling thing. I might not need that.


/**
 To use, uncomment the call in the AppDelegate
 This is normally not called, but it can be used to push hard coded test data into
 the dfile systemstore.
 */
@MainActor func primeFilesWithTestData() {
    SingleDDiskStore.shared.setDomain(domain: testEffortDomain)
        // strange pattern replicated from Scrumdinger tutorial app.
        // why does it create a domain store object with a domain object, then pass the domain object in the closure?
        // https://developer.apple.com/tutorials/app-dev-training/persisting-data
    Task {
        do {
            try await SingleDDiskStore.shared.save(domain: SingleDDiskStore.shared.domain)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}

// App Delegate added per Firebase setup instructions:
// https://console.firebase.google.com/u/0/project/endgoal/overview
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//         primeFilesWithTestData()
        // DISABLING FIRRESTORE
//        FirebaseApp.configure()
                
        return true
    }
    
    // todo this func is implemented because of an error, but the error might be from including Messaging that I am not using.
    // I have included all the packages.
    // DISABLING FIRRESTORE
//    func application(_ application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//      Messaging.messaging().apnsToken = deviceToken
//    }
}

let egEnv = EGEnvironment()

@main
struct End_GoalApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject private var store = DomainDiskStore()
    @StateObject private var store = SingleDDiskStore.shared
    @StateObject private var localDStore = LocalDataStore.shared

    var body: some Scene {
        WindowGroup {
            ContentView(domain: $store.domain, localData: $localDStore.localData, localDataSaveAction: localDataSaveAction )  { // saveAction: closure
                domainStoreSaveAction()
            }
            .environmentObject(egEnv)
            .task {
                do {
                    try await localDStore.load()
                        /**
                        In the future, this outcome may affect what store the next step loads from
                        depending on if we're set true for localData.useCloud
                        */
                    try await store.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Function falls through immediately kicking off a Task
     */
    func localDataSaveAction() {
        Task { // save localData
            do {
                try await localDStore.save(localData: localDStore.localData)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /**
     Function falls through immediately kicking off a Task
     */
    func domainStoreSaveAction() {
        Task { // save domain (aka EffortDomain)
            do {
                try await store.save(domain: store.domain)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
}


