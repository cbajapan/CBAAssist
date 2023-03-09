//
//  NativeViewRepresentable.swift
//  CBAAssist
//
//  Created by Cole M on 10/19/22.
//

import UIKit
import SwiftUI

struct NativeViewRepresentable: UIViewControllerRepresentable {
    
    @Binding var showPop: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = NativeViewController()
        vc.nativeDelegate = context.coordinator
     return vc
    }
    
    func updateUIViewController(_ viewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    
    class Coordinator: NSObject, NativeProtocol {
        
        var parent: NativeViewRepresentable
        var showPop: Bool? = false
        
        init(_ parent: NativeViewRepresentable) {
            self.parent = parent
        }
        
        func passShowPop(_ show: Bool) {
            print(show)
            self.parent.showPop = show
        }
    }
}

protocol NativeProtocol: AnyObject {
    func passShowPop(_ show: Bool)
}
