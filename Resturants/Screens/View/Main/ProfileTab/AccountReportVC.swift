//
//  AccountReportVC.swift
//  Resturants
//
//  Created by Coder Crew on 13/05/2024.
//

import UIKit

class AccountReportVC: UIViewController {

    //MARK: - IBOUtlet
    @IBOutlet weak var txtViewBio            : UITextView!
    @IBOutlet weak var switchVolience        : UISwitch!
    @IBOutlet weak var switchDefemation      : UISwitch!
    @IBOutlet weak var switchSelfHarm        : UISwitch!
    @IBOutlet weak var switchInsult          : UISwitch!
    @IBOutlet weak var switchCyberBullying   : UISwitch!
    @IBOutlet weak var switchUnlawfulThreats : UISwitch!
    @IBOutlet weak var switchNudity          : UISwitch!
    @IBOutlet weak var switchAnimalCruelty   : UISwitch!
    @IBOutlet weak var switchInappropriate   : UISwitch!
    @IBOutlet weak var switchTechError       : UISwitch!
    @IBOutlet weak var switchViolation       : UISwitch!
    @IBOutlet weak var switchOther           : UISwitch!
    @IBOutlet weak var switchFalseInfo       : UISwitch!
    
    
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
