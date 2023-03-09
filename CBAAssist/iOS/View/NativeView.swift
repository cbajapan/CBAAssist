//
//  NativeView.swift
//  CBAAssist
//
//  Created by Cole M on 3/2/22.
//

import SwiftUI

struct NativeView: View {
    
    @State var showDocPop: Bool = false
    @State var openPicker: Bool = false
    @State var filePath: URL? = nil
    @State var urlString: String = ""
    @EnvironmentObject var supportSessionManager: SupportSessionManager
    
    var body: some View {
        ZStack {
            if UIDevice.current.userInterfaceIdiom == .pad {
                Button("", action: {})
                    .popover(isPresented: $showDocPop) {
                        DocPopover(urlString: $urlString, openPicker: $openPicker)
                            .frame(width: 400, height: 400)
                    }
                NativeViewRepresentable(showPop: $showDocPop)
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                NativeViewRepresentable(showPop: $showDocPop)
                    .popover(isPresented: $showDocPop) {
                        DocPopover(urlString: $urlString, openPicker: $openPicker)
                    }
            }
        }
        .onChange(of: filePath) { newValue in
            Task {
                guard let uFilePath = newValue else { return }
                await sendURL(uFilePath)
                filePath = nil
            }
        }
        .onChange(of: urlString) { newValue in
            Task {
                if !newValue.isEmpty {
                    guard let url = URL(string: newValue) else { return }
                    await sendURL(url)
                    urlString = ""
                }
            }
        }
        .sheet(isPresented: $openPicker) {
            DocumentPicker(filePath: $filePath)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func sendURL(_ url: URL) async {
        await supportSessionManager.consumerShareURL(url)
    }
}

//struct NativeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NativeView()
//    }
//}
