//
//  NativeViewController.swift
//  CBAAssist
//
//  Created by Cole M on 10/19/22.
//

import UIKit


let LABEL_ID_TAG = 1000
let TXT_ID_TAG = 1001
let SLIDER_ID_TAG = 1002
let SWITCH_ID_TAG = 1003
let TXT_VIEW_ID_TAG = 1004
let SECURE_TXT_ID_TAG = 1005

let rowCnt = 25
let scrollViewTag = 600
let stepperValTag = 700

let webShareUrl = "http://developer.apple.com"
let webShareContent = "Resource_10276-KB-WebRTC"
let scrollContentMax: Double = 25

class NativeViewController: UINavigationController {
    
    weak var nativeDelegate: NativeProtocol?
    var showPop: Bool = false
    let vc = ControlsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([vc], animated: true)
         
        vc.scrollButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateScroll)))
        vc.tableButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateTable)))
        vc.singleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notifyDocClicked)))
    }

    @objc func navigateScroll() {
        _ = popToRootViewController(animated: true)
        let vc = ScrollViewController()
        self.pushViewController(vc, animated: true)
    }
    
    @objc func navigateTable() {
        _ = popToRootViewController(animated: true)
        let vc = TableViewController()
        self.pushViewController(vc, animated: true)
    }
    
    @objc func notifyDocClicked() {
        nativeDelegate?.passShowPop(showPop ? false : true)
    }
}
