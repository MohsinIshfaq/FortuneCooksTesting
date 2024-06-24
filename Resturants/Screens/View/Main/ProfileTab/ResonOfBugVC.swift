//
//  ResonOfBugVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/06/2024.
//

import UIKit

class ResonOfBugVC: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtViewBio       : UITextView!
    
    let placeholder                        = "Enter Here..."
    let placeholderColor                   = UIColor.lightGray
    var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onload()
    }

}

//MARK: - Setup Profile {}
extension ResonOfBugVC {
   
    func onload() {
      
        if tag == 0{
            self.navigationItem.title = "Bug"
            lblHeader.text = "Clarify describe where the bug is on the platform be detailed."
        }
        else{
            self.navigationItem.title = "Suggestions"
            lblHeader.text = "How can we make fortune cooks better."
        }
        removeNavBackbuttonTitle()
        setupPlaceholder()
    }
    
    func onAppear() {
        hidesBottomBarWhenPushed = false
    }
    
    func setupPlaceholder() {
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
}


// MARK: - UITextViewDelegate {}
extension ResonOfBugVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text      = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }
}
