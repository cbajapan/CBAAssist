//
//  DocumentShareView.swift
//  CBAAssist
//
//  Created by Cole M on 8/23/22.
//

import SwiftUI

struct DocumentShareView: View {
    
    @Binding var filePath: URL?
    
    var body: some View {
        DocumentPicker(filePath: $filePath)
    }
}


struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var filePath: URL?
    
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.allowsMultipleSelection = false
        if #available(iOS 16.0, *) {
            picker.directoryURL = .documentsDirectory
        }
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: DocumentPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: DocumentPicker
        
        init(parent1: DocumentPicker){
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let url = urls[0]
            guard url.startAccessingSecurityScopedResource() else {
                print("can't access")
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }
            parent.filePath = url
            
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                print("Failed to access security")
                return
            }
        }
    }
}


func del() {
    
}
