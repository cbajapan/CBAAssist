//
//  DocPopover.swift
//  CBAAssist
//
//  Created by Cole M on 10/21/22.
//

import SwiftUI

struct DocPopover: View {
    
    @State var url: String = "https://cba-japan.com"
    @Binding var urlString: String
    @Binding var openPicker: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Form {
                if #available(iOS 15.0, *) {
                    Section("Share URL") {
                        TextField("URL to share", text: $url)
                        Button("Send URL") {
                            urlString = url
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }

                if #available(iOS 15.0, *) {
                    Section("Share Content") {
                        Button("Use Picker to Share Content") {
                            openPicker = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            Spacer()
        }
    }
}
