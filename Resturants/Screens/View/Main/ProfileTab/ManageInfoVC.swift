//
//  ManageInfoVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/06/2024.
//

import UIKit

class ManageInfoVC: UIViewController {

    @IBOutlet weak var txtMondayOpening    : UITextField!
    @IBOutlet weak var txtMondayClosing    : UITextField!
    @IBOutlet weak var txtTuesdayOpening   : UITextField!
    @IBOutlet weak var txtTuesdayClosing   : UITextField!
    @IBOutlet weak var txtWednesdayOpening : UITextField!
    @IBOutlet weak var txtWednesdayClosing : UITextField!
    @IBOutlet weak var txtThrusdayOpening  : UITextField!
    @IBOutlet weak var txtThrusdayClosing  : UITextField!
    @IBOutlet weak var txtFridayOpening    : UITextField!
    @IBOutlet weak var txtFridayClosing    : UITextField!
    @IBOutlet weak var txtSaturdayOpening  : UITextField!
    @IBOutlet weak var txtSaturdayClosing  : UITextField!
    @IBOutlet weak var txtSundayOpening    : UITextField!
    @IBOutlet weak var txtSundayClosing    : UITextField!
    @IBOutlet weak var stackMonday         : UIStackView!
    @IBOutlet weak var lblMonday           : UILabel!
    @IBOutlet weak var stackTuesday        : UIStackView!
    @IBOutlet weak var lblTuesday          : UILabel!
    @IBOutlet weak var stackWednesday      : UIStackView!
    @IBOutlet weak var lblWednesday        : UILabel!
    @IBOutlet weak var stackThursday       : UIStackView!
    @IBOutlet weak var lblThursday         : UILabel!
    @IBOutlet weak var stackFriday         : UIStackView!
    @IBOutlet weak var lblFriday           : UILabel!
    @IBOutlet weak var stackSaturday       : UIStackView!
    @IBOutlet weak var lblSaturday         : UILabel!
    @IBOutlet weak var stackSunday         : UIStackView!
    @IBOutlet weak var lblSunday           : UILabel!
    @IBOutlet weak var txtViewBio          : UITextView!
    
    var selectedHrs                        = ""
    var selectedMins                       = ""
    let placeholder                        = "Enter Bio..."
    let placeholderColor                   = UIColor.lightGray
    private var AccntPicker                = UIPickerView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 150))
    var activeTextField: UITextField?      = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }

    @IBAction func ontapScheduleSwitch(_ sender: UISwitch){
        
        switch sender.tag {
        case 0:
            lblMonday.isHidden   = sender.isOn
            stackMonday.isHidden = switchStack(sender: sender.isOn)
            break
        case 1:
            lblTuesday.isHidden   = sender.isOn
            stackTuesday.isHidden = switchStack(sender: sender.isOn)
            break
        case 2:
            lblWednesday.isHidden   = sender.isOn
            stackWednesday.isHidden = switchStack(sender: sender.isOn)
            break
        case 3:
            lblThursday.isHidden   = sender.isOn
            stackThursday.isHidden = switchStack(sender: sender.isOn)
            break
        case 4:
            lblFriday.isHidden   = sender.isOn
            stackFriday.isHidden = switchStack(sender: sender.isOn)
            break
        case 5:
            lblSaturday.isHidden   = sender.isOn
            stackSaturday.isHidden = switchStack(sender: sender.isOn)
            break
        case 6:
            lblSunday.isHidden   = sender.isOn
            stackSunday.isHidden = switchStack(sender: sender.isOn)
            break
        default: break
        }
    }
    
}

//MARK: - Setup Profile {}
extension ManageInfoVC {
   
    func onload() {
        self.navigationItem.title = "Manage information"
        removeNavBackbuttonTitle()
        txtViewBio.delegate   = self
        setupPlaceholder()
        setupPickerView()
    }
    
    func onAppear() {
    }
    
    func setupPlaceholder() {
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
    
    func setupPickerView() {
        txtMondayOpening.inputView     = AccntPicker
        txtMondayClosing.inputView     = AccntPicker
        
        txtTuesdayOpening.inputView    = AccntPicker
        txtTuesdayClosing.inputView    = AccntPicker
        
        txtWednesdayOpening.inputView  = AccntPicker
        txtWednesdayClosing.inputView  = AccntPicker
        
        txtThrusdayOpening.inputView   = AccntPicker
        txtThrusdayClosing.inputView   = AccntPicker
        
        txtFridayOpening.inputView     = AccntPicker
        txtFridayClosing.inputView     = AccntPicker
        
        txtSaturdayOpening.inputView   = AccntPicker
        txtSaturdayClosing.inputView   = AccntPicker
        
        txtSundayOpening.inputView     = AccntPicker
        txtSundayClosing.inputView     = AccntPicker
        
        // Set the text field delegates
        txtMondayOpening.delegate     = self
        txtMondayClosing.delegate     = self
        
        txtTuesdayOpening.delegate    = self
        txtTuesdayClosing.delegate    = self
        
        txtWednesdayOpening.delegate  = self
        txtWednesdayClosing.delegate  = self
        
        txtThrusdayOpening.delegate   = self
        txtThrusdayClosing.delegate   = self
        
        txtFridayOpening.delegate     = self
        txtFridayClosing.delegate     = self
        
        txtSaturdayOpening.delegate   = self
        txtSaturdayClosing.delegate   = self
        
        txtSundayOpening.delegate     = self
        txtSundayClosing.delegate     = self
        
        AccntPicker.delegate          = self
        AccntPicker.backgroundColor   = .white
    }
    
    func switchStack(sender: Bool) -> Bool {
        if sender {
            return false
        }
        else{
            return true
        }
    }
}

//MARK: -  Extend the class to conform to UITextFieldDelegate
extension ManageInfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

// MARK: - UITextViewDelegate {}
extension ManageInfoVC : UITextViewDelegate{
    
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

//MARK: - Picker View for Schedule Selection {}
extension ManageInfoVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return UserManager.shared.arrHour.count
        }
        else{
            return UserManager.shared.arrMints.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return UserManager.shared.arrHour[row]
        }
        else{
            return UserManager.shared.arrMints[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            selectedHrs = UserManager.shared.arrHour[row]
        } else {
            selectedMins = UserManager.shared.arrMints[row]
        }
        
        // Update the active text field
        if let activeTextField = activeTextField {
            activeTextField.text = "\(selectedHrs) : \(selectedMins)"
        }
    }
}
