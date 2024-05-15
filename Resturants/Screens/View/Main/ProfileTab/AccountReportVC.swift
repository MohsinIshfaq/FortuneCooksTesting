//
//  AccountReportVC.swift
//  Resturants
//
//  Created by Coder Crew on 13/05/2024.
//

import UIKit

class AccountReportVC: UIViewController {

    //MARK: - IBOUtlet
    @IBOutlet weak var txtViewBio       : UITextView!
    
    //MARK: - Variables and Properties
    let placeholder                        = " Write Here..."
    let placeholderColor                   = UIColor.lightGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
}

//MARK: - setup Profile {}
extension AccountReportVC {
    
    func onLoad() {
        setupPlaceholder()
    }

    func setupPlaceholder() {
        txtViewBio.delegate  = self
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
    
    func onAppear() {
        self.navigationItem.title  = "Account Report"
        removeNavBackbuttonTitle()
    }
}

// MARK: - UITextViewDelegate {}
extension AccountReportVC : UITextViewDelegate{
    
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
