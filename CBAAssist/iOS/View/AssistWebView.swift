//
//  AssistWebView.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import SwiftUI
import WebKit

struct AssistWebView: View {
    
    @State var showSupportAlert = false
    @State var backId: UUID? = nil
    @State var forwardId: UUID? = nil
    @State var refreshId: UUID? = nil
    @State var shortCode = ""
    @State var showDocs = false
    @State var documentURL: URL?
    @State var webView = WKWebView()
    @State var showPopover = false
    
    @EnvironmentObject var supportSessionManager: SupportSessionManager
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        if #available(iOS 15.0, *) {
            ZStack {
                ConnectionView()
                AssistWebViewRepresentable(
                    webView: webView,
                    forwardId: self.$forwardId,
                    backId: self.$backId,
                    refreshId: self.$refreshId
                )
                .onAppear {
                    let request = URLRequest(url: URL(string: "\(appSettings.website)") ?? URL(string: "https://cba-japan.com")!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
                    _  = webView.load(request)
                }
                .onChange(of: appSettings.website) { newValue in
                      let request = URLRequest(url: URL(string: "\(newValue)") ?? URL(string: "https://cba-japan.com")!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
                    _  = webView.load(request)
                }
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            showSupportAlert = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.backId = UUID()
                        }) {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.forwardId = UUID()
                        }) {
                            Image(systemName: "chevron.forward")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.refreshId = UUID()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.showDocs = true
                        }) {
                            Image(systemName: "doc.richtext.fill")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.showPopover = true
                        }) {
                            Image(systemName: "network")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }.popover(
                            isPresented: self.$showPopover,
                            arrowEdge: .bottom
                        ) {
                            TextField("Enter a new web address", text: $appSettings.website)
                                .font(.body)
                                .padding()
                        }
                        Spacer()
                    }
                    .background(Color.white.opacity(0.40))
                }
            }
            .onChange(of: self.documentURL, perform: { newValue in
                Task {
                    if let newValue = newValue {
                        await supportSessionManager.consumerShareURL(newValue)
                    }
                    self.documentURL = nil
                }
            })
            .fullScreenCover(isPresented: $showDocs, content: {
                DocumentShareView(filePath: $documentURL)
            })
            .alert("Share my screen with the support agent?", isPresented: $showSupportAlert) {
                Button("Call support then share") {
                    //We want to invoke our LASDK Method in the View Model
                    Task {
                        await supportSessionManager.startSupportSession()
                    }
                }
                Button("Already on a call, let's share") {
                    //We want to invoke our LASDK Method in the View Model
                    Task {
                        await supportSessionManager.requestShortCode()
                        self.showSupportAlert = false
                    }
                }
                Button("I dont need help") {
                    //Just Dismiss
                }
            }
            .alert("The Short Code is \(self.supportSessionManager.shortCode)", isPresented: self.$supportSessionManager.presentShortCode) {
                Button("Cancel Support") {
                    Task {
                        await self.supportSessionManager.dismissShortCode()
                    }
                }
                Button("Copy Code") {
                    self.supportSessionManager.copyCode()
                }
            }
        } else {
            ZStack {
                AssistWebViewRepresentable(
                    webView: webView,
                    forwardId: self.$forwardId,
                    backId: self.$backId,
                    refreshId: self.$refreshId
                )
                .onAppear {
                    let request = URLRequest(url: URL(string: "\(appSettings.website)")!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
                    _  = webView.load(request)
                }
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            showSupportAlert = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.backId = UUID()
                        }) {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.forwardId = UUID()
                        }) {
                            Image(systemName: "chevron.forward")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.refreshId = UUID()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }
                        Button(action: {
                            self.showDocs = true
                        }) {
                            Image(systemName: "doc.fill")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .padding()
                        }
                        Spacer()
                    }
                    .background(Color.white.opacity(0.40))
                }
            }
            .fullScreenCover(isPresented: $showDocs, content: {
                DocumentShareView(filePath: $documentURL)
            })
            .alert(isPresented: $showSupportAlert) {
                Alert(title: Text("Share my screen with the support agent?"),
                      message: Text(""),
                      primaryButton: .default(Text("Call support then share"), action: {
                    Task {
                        await supportSessionManager.startSupportSession()
                    }
                }), secondaryButton: .default(Text("Already on a call, let's share"), action: {
                    Task {
                        await supportSessionManager.requestShortCode()
                    }
                }))
            }
        }
    }
}
