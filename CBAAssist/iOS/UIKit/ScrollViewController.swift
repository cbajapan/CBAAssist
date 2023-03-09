//
//  ScrollViewController.swift
//  CBAAssist
//
//  Created by Cole M on 10/20/22.
//

import UIKit

class ScrollViewController: UIViewController {
    
    var singleScrollView: UIScrollView = {
        var s = UIScrollView()
        s.tag = scrollViewTag
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(singleScrollView)
        singleScrollView.translatesAutoresizingMaskIntoConstraints = false
        singleScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        singleScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        singleScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        singleScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        addScrollViewContents()
    }
    
    
    func addScrollViewContents() {

        singleScrollView.isScrollEnabled = true
        singleScrollView.contentSize = CGSize(width: view.frame.size.width, height: (scrollContentMax * 30))

        for idx in 0..<Int(scrollContentMax) {
            let lab = UILabel(frame: CGRect(x: 0, y: CGFloat(idx * 30), width: view.frame.size.width, height: 30))
            lab.textColor = .white
            lab.text = "Scroll View Content \(idx)"
            singleScrollView.addSubview(lab)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
