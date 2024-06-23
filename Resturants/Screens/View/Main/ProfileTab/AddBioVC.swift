//
//  AddBioVC.swift
//  Resturants
//
//  Created by Coder Crew on 23/06/2024.
//

import UIKit

class AddBioVC: UIViewController {

    @IBOutlet weak var txtViewBio       : UITextView!
    
    let placeholder                        = "Enter Bio..."
    let placeholderColor                   = UIColor.lightGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
}

//MARK: - Custom Implementation {}
extension AddBioVC{
   
    func onLaod() {
        txtViewBio.delegate   = self
        setupPlaceholder()
        self.navigationItem.title = "Add Bio"
        removeNavBackbuttonTitle()
    }
    
    func setupPlaceholder() {
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
    
    func onAppear() {
    }
    
}

// MARK: - UITextViewDelegate {}
extension AddBioVC : UITextViewDelegate{
    
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
