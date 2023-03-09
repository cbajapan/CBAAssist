//
//  AppSettingsView.swift
//  CBAAssist
//
//  Created by Cole M on 11/9/22.
//

import SwiftUI
import LASDKiOS

struct AppSettingsView: View {
    
    
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Group {
                        Section(header: Text("Assist SDK Version")) {
                            Text(appSettings.version)
                        }
                    }
                    Group {
                        Section(header: Text("Set Auto Start")) {
                            VStack(alignment: .leading) {
                                Toggle("Auto Start", isOn: $appSettings.autoStart)
                            }
                        }
                        Section(header: Text("Set Accept Self Signed Certificates")) {
                            VStack(alignment: .leading) {
                                Toggle("Accept Self Signed Certificates", isOn: $appSettings.acceptSelfSignedCerts)
                            }
                        }
                        Section(header: Text("Set WebView URL")) {
                            TextField("URL", text:  $appSettings.website)
                        }
                        Section(header: Text("Set Live Assist Support URL")) {
                            TextField("URL", text:  $appSettings.supportServerAddess)
                                .lasdkTextField { view in
                                view.tag = 500
                            }
                        }
                        Section(header: Text("Set User Agent")) {
                            TextField("Agent", text:  $appSettings.agent)
                                .lasdkTextField { view in
                                view.tag = 501
                            }
                        }
                        Section(header: Text("Set Username")) {
                            TextField("Username", text:  $appSettings.username)
                        }
                        Section(header: Text("CorrelationId")) {
                            TextField("CorrelationId", text:  $appSettings.correlationId)
                                .lasdkTextField { view in
                                view.tag = 502
                            }
                        }
                        Section(header: Text("Set Audit Name")) {
                            TextField("Audit Name", text:  $appSettings.auditName)
                        }
                        Section(header: Text("Set User Info")) {
                            TextField("User Info", text:  $appSettings.userToUserInfo)
                            SecureField("This secure text serves no real purpose", text:  $appSettings.secureText)
                        }
                        HStack {
                            Spacer()
                            Button {
                                saveInfo()
                            } label: {
                                Text("Save")
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
            }
            .navigationBarTitle("App Settings")
        }
    }
    
    func saveInfo() {
        UserDefaults.standard.set(appSettings.website, forKey: "Website")
        UserDefaults.standard.set(appSettings.supportServerAddess, forKey: "SupportURL")
        UserDefaults.standard.set(appSettings.iconImage, forKey: "IconImage")
        UserDefaults.standard.set(appSettings.agent, forKey: "Agent")
        UserDefaults.standard.set(appSettings.username, forKey: "Username")
        UserDefaults.standard.set(appSettings.correlationId, forKey: "CorrelationID")
        UserDefaults.standard.set(appSettings.userToUserInfo, forKey: "UserInfo")
        UserDefaults.standard.set(appSettings.auditName, forKey: "AuditName")
        UserDefaults.standard.set(appSettings.autoStart, forKey: "AutoStart")
        UserDefaults.standard.set(appSettings.acceptSelfSignedCerts, forKey: "AcceptSelfSignedCerts")
    }
}
