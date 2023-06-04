//
//  ContentView.swift
//  End Goal
//
//  Created by Paul Sons on 5/17/23.
//

import SwiftUI
// DISABLING FIRRESTORE
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseFirestoreSwift

/**
 Observe the egEnv.dStore and when it isActive enableTabs
 When tabs are enabled, the user can use the data manipulation tabs.
 Otherwise only the setting tab is enabled.
 See
 */
struct ContentView: View {
    //    @EnvironmentObject var egEnv: EGEnvironment
    @Binding var domain: EffortDomain
    @Binding var localData: LocalData
    // DISABLING FIRRESTORE
//    var db: Firestore = Firestore.firestore()
    @State var localDataSaveAction: ()->Void // saves localData
    @State var saveAction: ()->Void // saves domain
    
    var body: some View {
        TabView {
            DomainTab(domain: domain, saveAction: saveAction)
                .tabItem {
                    Label("Plan", systemImage:"list.bullet.indent")
                }
            SettingsTab(localData: localData, localDataSaveAction: localDataSaveAction)
                .tabItem {
                    Label("settings", systemImage:"gearshape")
                }
                .padding()
        }.onAppear {
            // WAS ALREADY COMMENTED OUT WHEN I DID DISABLE: domainFromFireStore() // do this in the App. dont forgret to: db: Firestore = Firestore.firestore()
        } // onAppear
    }
    
    // DISABLING FIRRESTORE
//    func domainFromFireStore() {
//        let docRef = db.collection("Domains").document("Fp5sNlJ8rLpebBSwUeoe")
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//                do {
//                    domain = try document.data(as: EffortDomain.self)
//                    print(domain)
//                    print(".onAppear closure decoded domain name: \(domain.name)")
//                }
//                catch {
//                  print(error)
//                }
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            domain: .constant(EffortDomain(name: "Preview Effort Domain")),
            localData: .constant(LocalData()),
            localDataSaveAction: {}, saveAction: {})
    }
}
