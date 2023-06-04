//
//  LoginTab.swift
//  psons-tv-su
//
//  Created by Paul Sons on 5/13/23.
//

import SwiftUI

struct SettingsTab: View {
    @EnvironmentObject var egEnv: EGEnvironment
    @ObservedObject var localData: LocalData
    @State var localpassword: String = ""
    @State var localEmail: String = ""
    @State var shouldShowProfileAlert: Bool = false
    @FocusState var profileInfoIsFocused: Bool
    var localDataSaveAction: ()->Void

    let formRowInsets = EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
    let extraTopInsets = EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
    let overallPadInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

    init(localData: LocalData, localDataSaveAction: @escaping ()->Void) {
        self.localData = localData
        self.localDataSaveAction = localDataSaveAction
    }
    
    
    let screenSideMargin: CGFloat = 20

    var body: some View {
        ZStack {
            Color("SettingTabBackground")
            VStack{
                Spacer()
                HStack {
                    Spacer().frame(width: screenSideMargin) // left margin
                    VStack {
                        
                        Toggle("Use Cloud:", isOn: $localData.useCloud).font(.title).foregroundColor(.white)
                        if localData.useCloud {
                            Grid(alignment: .leading) {
                                GridRow {
    //                                Spacer().frame(height: 50)
                                    Text("Create User:").font(.title).foregroundColor(.white)
                                }.gridCellColumns(2)
                                GridRow {
                                    Text("e-mail: ").gridColumnAlignment(.leading).foregroundColor(.white)
                                    TextField(
                                        "Enter e-mail as user name",
                                        text: self.$localEmail).disabled(!localData.useCloud)
                                    .textFieldStyle(.roundedBorder)
                                    .foregroundColor(.blue)
                                }.padding(formRowInsets)
                                GridRow {
                                    Text("Password: ").foregroundColor(.white)
                                    SecureField("Enter password", text: $localpassword) {
                                        debugPrint("edit done on secure field")
                                    }.disabled(!localData.useCloud)
                                    .textFieldStyle(.roundedBorder)
                                    .foregroundColor(.blue)
                                }
                            }
                            HStack {
                                Button {
    //                                profileInfoIsFocused = false
                                    shouldShowProfileAlert = true
                                    egEnv.uStore.userState.userEmail = localEmail
                                    egEnv.uStore.userState.userPassword = localpassword
                                    
                                } label: {
                                    Text("Create")
                                        .frame(maxWidth: .infinity)
                                }.buttonStyle(.borderedProminent)
                                    .alert(isPresented: $shouldShowProfileAlert) {
                                        Alert(
                                            title: Text("Your Profile will be updated"),
                                            message: Text("if you confirm: "),
                                            primaryButton:
                                                    .default(Text("Confirm"),
                                                             action: {
                                                                 print("Disabled Firestore")
                                                                 // DISABLING FIRRESTORE
//                                                                 egEnv.auth.signUpUser(userEMail: egEnv.uStore.userState.userEmail, userPassword: egEnv.uStore.userState.userPassword)
                                                                 
                                                             }
                                                            ),
                                            secondaryButton:
                                                    .destructive(Text("Cancel"),
                                                                 action: {})
                                        )
                                    }
                                Button {
                                    // DISABLING FIRRESTORE
//                                    egEnv.auth.loginUser(userEMail: egEnv.uStore.userState.userEmail, userPassword: egEnv.uStore.userState.userPassword)
                                } label: {
                                    Text("Login")
                                        .frame(maxWidth: .infinity)
                                }.buttonStyle(.borderedProminent)

                            }
                        }

                        
                        HStack {
                            Spacer()//.frame(height: 300)
                        }
                        
                    }
                    .padding(overallPadInsets)
                    //                    .background(Color.green)
                    .font(.headline)
                    Spacer().frame(width: screenSideMargin) // right margin
                }
                Spacer()
}
        }.onChange(of: localData.useCloud) { useCloud in
            print("useCloud: \(useCloud)")
            localDataSaveAction() // calling the closure passed all the way from App Level
        }
    }
    
    
}

struct SettingTab_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTab(localData: LocalData(), localDataSaveAction: {})
    }
}
