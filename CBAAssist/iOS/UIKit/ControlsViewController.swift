//
//  ControlsViewController.swift
//  CBAAssist
//
//  Created by Cole M on 10/20/22.
//

import UIKit

class ControlsViewController: UIViewController {
    
    let scrollButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.setTitle("Scroll View", for: .normal)
        return btn
    }()
    let tableButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 8
        btn.tag = 507
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.setTitle("Table View", for: .normal)
        return btn
    }()
    
    var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .firstBaseline
        stack.spacing = 10
        return stack
    }()

    var switchStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .firstBaseline
        stack.spacing = 5
        return stack
    }()
    
    var stepperStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .firstBaseline
        stack.spacing = 5
        return stack
    }()
    
    var switchLabel: UILabel = {
        let label = UILabel()
        label.text = "Hide Controls"
        label.tag = LABEL_ID_TAG
        return label
    }()
    var singleSwitch: UISwitch = {
        let s = UISwitch()
        s.tag = SWITCH_ID_TAG
        return s
    }()
    var singleTextField: UITextField = {
        let s = UITextField()
        s.placeholder = "Text Field"
        s.tag = TXT_ID_TAG
        return s
    }()
    var singleTextView: UITextView = {
        let s = UITextView()
        s.backgroundColor = .secondarySystemBackground
        s.tag = TXT_VIEW_ID_TAG
        return s
    }()
    var singleDatePicker = UIDatePicker()
    var singleStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.wraps = false
        stepper.autorepeat = true
        stepper.maximumValue = 10
        return stepper
    }()
    var singleStepperLabel: UILabel = {
        let label = UILabel()
        label.tag = stepperValTag
        return label
    }()
    var singleSegment: UISegmentedControl = {
        let s = UISegmentedControl(items: ["First", "Second", "Third"])
        return s
    }()
    var singleSlider: UISlider = {
        let s = UISlider()
        s.tag = SLIDER_ID_TAG
        return s
    }()
    var singleButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setTitle("Share Document", for: .normal)
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return btn
    }()
    var secureTextField: UITextField = {
        let txt = UITextField()
        txt.isSecureTextEntry = true
        txt.placeholder = "Secure Text Field"
        txt.tag = SECURE_TXT_ID_TAG
        return txt
    }()
    var scrollView = UIScrollView()

    let singleContentView = UIView()
    
    var stackView: UIStackView = {
       var stack = UIStackView()
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrangements()
        constraints()
    
        actions()
        
//        [[DynamicMasker sharedInstance] storeHiddenOrMaskedViews:[self.view subviews]];
//        [[DynamicMasker sharedInstance] setHidingAndMasking:false];
    }
    
    fileprivate func arrangements() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(singleContentView)
        singleContentView.addSubview(stackView)
        buttonStack.addArrangedSubview(scrollButton)
        buttonStack.addArrangedSubview(tableButton)
        switchStack.addArrangedSubview(switchLabel)
        switchStack.addArrangedSubview(singleSwitch)
        stepperStack.addArrangedSubview(singleStepper)
        stepperStack.addArrangedSubview(singleStepperLabel)
        stackView.addArrangedSubview(buttonStack)
        stackView.addArrangedSubview(switchStack)
        stackView.addArrangedSubview(singleTextField)
        stackView.addArrangedSubview(secureTextField)
        stackView.addArrangedSubview(singleTextView)
        stackView.addArrangedSubview(stepperStack)
        stackView.addArrangedSubview(singleSlider)
        stackView.addArrangedSubview(singleSegment)
        stackView.addArrangedSubview(singleDatePicker)
        stackView.addArrangedSubview(singleButton)
    }
    
    fileprivate func constraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true


        singleContentView.translatesAutoresizingMaskIntoConstraints = false
        singleContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        singleContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        singleContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        singleContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        
        singleTextField.translatesAutoresizingMaskIntoConstraints = false
        singleTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        singleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        secureTextField.translatesAutoresizingMaskIntoConstraints = false
        secureTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        secureTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        singleTextView.translatesAutoresizingMaskIntoConstraints = false
        singleTextView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        singleTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        singleSlider.translatesAutoresizingMaskIntoConstraints = false
        singleSlider.widthAnchor.constraint(equalToConstant: 300).isActive = true
        singleSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: singleContentView.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: singleContentView.leadingAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: singleContentView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func actions() {
        singleStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)

    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        let label = view.viewWithTag(stepperValTag) as? UILabel
        label?.text = "\(sender.value).f"
    }
    
    @objc func changeSensitiveMaskingSetting(_ switch: UISwitch) {
//        [[DynamicMasker sharedInstance] setHidingAndMasking:[switch isOn]?true:false];
    }
    

}
