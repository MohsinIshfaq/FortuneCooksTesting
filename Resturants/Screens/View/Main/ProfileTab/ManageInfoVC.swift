//
//  ManageInfoVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/06/2024.
//

import UIKit
import FirebaseFirestoreInternal

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
    @IBOutlet weak var txtChannelNm        : UITextField!
    @IBOutlet weak var txtEmail            : UITextField!
    @IBOutlet weak var txtWeb              : UITextField!
    @IBOutlet weak var txtNumber           : UITextField!
    @IBOutlet weak var txtAddress          : UITextField!
    @IBOutlet weak var txtZip              : UITextField!
    @IBOutlet weak var txtCity             : UITextField!
    
    @IBOutlet weak var switchMonday        : UISwitch!
    @IBOutlet weak var switchTuesday       : UISwitch!
    @IBOutlet weak var switchWednesday     : UISwitch!
    @IBOutlet weak var switchThrusday      : UISwitch!
    @IBOutlet weak var switchFriday        : UISwitch!
    @IBOutlet weak var switchSaturday      : UISwitch!
    @IBOutlet weak var switchSunday        : UISwitch!
    @IBOutlet weak var btnSave             : UIButton!
    
    var selectedHrs                        = "00"
    var selectedMins                       = "00"
    let placeholder                        = "Enter Bio..."
    let placeholderColor                   = UIColor.lightGray
    private var AccntPicker                = UIPickerView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 150))
    var activeTextField: UITextField?      = nil
    var isFromNewLocation: Bool            = false
    var location : RestaurantLocation?     = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapSave(_ sender: UIButton) {
        if isFromNewLocation {
            if validateFields(email: txtEmail.text, web: txtWeb.text , name: txtChannelNm.text , descrip: txtViewBio.text , number: txtNumber.text , address: txtAddress.text , zipCode: txtZip.text , city: txtCity.text) && txtViewBio.text != "" {
                addLocationOfResturant()
            }
            else{
                self.showToast(message: "Bio is not valid.", seconds: 2, clr: .red)
            }
        }
        else{
            if validateFields(email: txtEmail.text, web: txtWeb.text , name: txtChannelNm.text , descrip: txtViewBio.text , number: txtNumber.text , address: txtAddress.text , zipCode: txtZip.text , city: txtCity.text) && txtViewBio.text != "" {
                UpdateLocation()
            }
            else{
                self.showToast(message: "Bio is not valid.", seconds: 2, clr: .red)
            }
        }
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

//MARK: - Setup location? {}
extension ManageInfoVC {
   
    func onload() {
        if isFromNewLocation {
            self.navigationItem.title = "Add Location"
        }
        else{
            self.navigationItem.title = "Manage information"
        }
        removeNavBackbuttonTitle()
        txtViewBio.delegate   = self
        setupPlaceholder()
        setupPickerView()
    }
    
    func onAppear() {
        
        if !isFromNewLocation{
            setupData()
            btnSave.setTitle("Update", for: .normal)
        }
        else{
            btnSave.setTitle("Save", for: .normal)
        }
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
    
    func getMondaySchedule(_ opening: String,  _ closing: String , switchs: Bool) -> String {
        //MARK: - if switch is hide it means schedule is closed like monday is closed
        return switchs ? "\(opening) - \(closing)" : "Closed"
    }
    
    func validateFields(email: String?, web: String? , name: String? , descrip: String? , number: String? , address: String? , zipCode: String? , city: String?) -> Bool  {
        if let email = email, !email.isEmpty {
            guard "".isValidEmailRegex(email) else {
                self.showToast(message: "Email is not valid.", seconds: 2, clr: .red)
                print("Invalid email address")
                return false
            }
        }
        
        if let web = web, !web.isEmpty {
            guard "".isValidWebsite(url: web) else {
                self.showToast(message: "web URL is not valid.", seconds: 2, clr: .red)
                return false
            }
        }
        
        if let name = name , !name.isEmpty{
            self.showToast(message: "channel name should'nt empty. ", seconds: 2, clr: .red)
            return false
        }
        if let descrip = descrip , !descrip.isEmpty{
            self.showToast(message: "Bio should'nt empty. ", seconds: 2, clr: .red)
            return false
        }
        if let number = number , !number.isEmpty{
            self.showToast(message: "number should'nt empty. ", seconds: 2, clr: .red)
            return false
        }
        if let address = address , !address.isEmpty{
            self.showToast(message: "Address should'nt empty. ", seconds: 2, clr: .red)
            return false
        }
        if let zipCode = zipCode , !zipCode.isEmpty{
            self.showToast(message: "ZipCode should'nt empty. ", seconds: 2, clr: .red)
            return false
        }
        if let city = city , !city.isEmpty{
            self.showToast(message: "City should'nt empty. ", seconds: 2, clr: .red)
            return false
        }
        
        return true
    }
    
    func setupData() {
        txtChannelNm.text = location?.channalNm ?? ""
        txtViewBio.text   = location?.bio ?? ""
        txtEmail.text     = location?.email ?? ""
        txtWeb.text       = location?.website ?? ""
        txtNumber.text    = location?.telephoneNumber ?? ""
        txtAddress.text   = location?.address ?? ""
        txtZip.text       = location?.zipCode ?? ""
        txtCity.text      = location?.City ?? ""
        txtAddress.text   = location?.address ?? ""
        if !(location?.timings?.isEmpty ?? false){
            txtMondayOpening.text    = location?.timings?[0] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[0] ?? "")?.0
            txtMondayClosing.text    = location?.timings?[0] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[0] ?? "")?.1
            lblMonday.isHidden    = location?.timings?[0] == "Closed" ? false : true
            stackMonday.isHidden  = location?.timings?[0] == "Closed" ? true : false
            switchMonday.isOn     = location?.timings?[0] == "Closed" ? false : true
            
            txtTuesdayOpening.text   = location?.timings?[1] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[1] ?? "")?.0
            txtTuesdayClosing.text   = location?.timings?[1] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[1] ?? "")?.1
            lblTuesday.isHidden   = location?.timings?[1] == "Closed" ? false : true
            stackTuesday.isHidden = location?.timings?[1] == "Closed" ? true : false
            switchTuesday.isOn    = location?.timings?[1] == "Closed" ? false : true
            
            txtWednesdayOpening.text = location?.timings?[2] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[2] ?? "")?.0
            txtWednesdayClosing.text = location?.timings?[2] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[2] ?? "")?.1
            lblWednesday.isHidden   = location?.timings?[2] == "Closed" ? false : true
            stackWednesday.isHidden = location?.timings?[2] == "Closed" ? true : false
            switchWednesday.isOn    = location?.timings?[2] == "Closed" ? false : true
            
            txtThrusdayOpening.text  = location?.timings?[3] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[3] ?? "")?.0
            txtThrusdayClosing.text  = location?.timings?[3] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[3] ?? "")?.1
            lblThursday.isHidden   = location?.timings?[3] == "Closed" ? false : true
            stackThursday.isHidden = location?.timings?[3] == "Closed" ? true : false
            switchThrusday.isOn    = location?.timings?[3] == "Closed" ? false : true
            
            txtFridayOpening.text    = location?.timings?[4] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[4] ?? "")?.0
            txtFridayClosing.text    = location?.timings?[4] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[4] ?? "")?.1
            lblFriday.isHidden   = location?.timings?[4] == "Closed" ? false : true
            stackFriday.isHidden = location?.timings?[4] == "Closed" ? true : false
            switchFriday.isOn    = location?.timings?[4] == "Closed" ? false : true
            
            txtSaturdayOpening.text  = location?.timings?[5] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[5] ?? "")?.0
            txtSaturdayClosing.text  = location?.timings?[5] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[5] ?? "")?.1
            lblSaturday.isHidden   = location?.timings?[5] == "Closed" ? false : true
            stackSaturday.isHidden = location?.timings?[5] == "Closed" ? true : false
            switchSaturday.isOn    = location?.timings?[5] == "Closed" ? false : true
            
            
            txtSundayOpening.text    = location?.timings?[6] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[6] ?? "")?.0
            txtSundayClosing.text    = location?.timings?[6] == "Closed" ? "00:00" : splitTimeRange(location?.timings?[6] ?? "")?.1
            lblSunday.isHidden   = location?.timings?[6] == "Closed" ? false : true
            stackSunday.isHidden = location?.timings?[6] == "Closed" ? true : false
            switchSunday.isOn    = location?.timings?[6] == "Closed" ? false : true
        }
    }
    
    func splitTimeRange(_ timeRange: String) -> (String, String)? {
        let components = timeRange.split(separator: "-")
        guard components.count == 2 else { return nil }
        let startTime = String(components[0])
        let endTime = String(components[1])
        return (startTime, endTime)
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

//get menus
extension ManageInfoVC  {
    
    func addLocationOfResturant() {
        self.startAnimating()
        var timings = [
            getMondaySchedule(txtMondayOpening.text ?? "", txtMondayClosing.text!, switchs: lblMonday.isHidden) ,
            getMondaySchedule(txtTuesdayOpening.text ?? "", txtTuesdayClosing.text!, switchs: lblTuesday.isHidden) ,
            getMondaySchedule(txtWednesdayOpening.text ?? "", txtWednesdayClosing.text!, switchs: lblWednesday.isHidden) ,
            getMondaySchedule(txtThrusdayOpening.text ?? "", txtThrusdayClosing.text!, switchs: lblThursday.isHidden) ,
            getMondaySchedule(txtFridayOpening.text ?? "", txtFridayClosing.text!, switchs: lblFriday.isHidden) ,
            getMondaySchedule(txtSaturdayOpening.text ?? "", txtSaturdayClosing.text!, switchs: lblSaturday.isHidden) ,
            getMondaySchedule(txtSundayOpening.text ?? "", txtSundayClosing.text!, switchs: lblSunday.isHidden)]
        print(timings)
        let uniqueID = UUID().uuidString
        let db = Firestore.firestore()
        let restaurantLocation = RestaurantLocation(
            id: uniqueID , channalNm: txtChannelNm.text!, bio: txtViewBio.text, email: txtEmail.text!, website: txtWeb.text!, telephoneNumber: txtNumber.text!, address: txtAddress.text!, zipCode: txtZip.text!, City: txtCity.text!, timings: timings)
        
        let collectionPath = "restaurants_Locations/\(UserDefault.token)/locations"
        db.collection(collectionPath).addDocument(data: restaurantLocation.toDictionary()) { error in
            if let error = error {
                print("Error saving location: \(error.localizedDescription)")
            } else {
                self.stopAnimating()
                self.menuGroups(id: uniqueID)
            }
        }
    }
    
    func menuGroups(id: String) {
        let uniqueID = UUID().uuidString
        let groupName = "Popular"
        
        let db = Firestore.firestore()
        self.startAnimating()
        
        let group: [String: Any] = [
            "uniqueID": uniqueID,
            "groupName": groupName
        ]
        
        // Creating an array of groups, even if it's just one for now
        let data: [String: Any] = [
            "groups": [group] // Storing the group in an array
        ]
        
        db.collection("groupsNames").document(id).setData(data) { error in
            self.stopAnimating()
            if let error = error {
                print("Error saving document: \(error.localizedDescription)")
            } else {
                self.showToast(message: "Group successfully saved!", seconds: 2, clr: .gray)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.popup()
                }
            }
        }
    }

    
    func UpdateLocation() {
        self.startAnimating()
        
        // Prepare the timings array
        let timings = [
            getMondaySchedule(txtMondayOpening.text ?? "", txtMondayClosing.text!, switchs: lblMonday.isHidden),
            getMondaySchedule(txtTuesdayOpening.text ?? "", txtTuesdayClosing.text!, switchs: lblTuesday.isHidden),
            getMondaySchedule(txtWednesdayOpening.text ?? "", txtWednesdayClosing.text!, switchs: lblWednesday.isHidden),
            getMondaySchedule(txtThrusdayOpening.text ?? "", txtThrusdayClosing.text!, switchs: lblThursday.isHidden),
            getMondaySchedule(txtFridayOpening.text ?? "", txtFridayClosing.text!, switchs: lblFriday.isHidden),
            getMondaySchedule(txtSaturdayOpening.text ?? "", txtSaturdayClosing.text!, switchs: lblSaturday.isHidden),
            getMondaySchedule(txtSundayOpening.text ?? "", txtSundayClosing.text!, switchs: lblSunday.isHidden)
        ]
        
        let db = Firestore.firestore()
        
        // Create the restaurant location object
        let restaurantLocation = RestaurantLocation(
            id: location?.id ?? "",
            channalNm: txtChannelNm.text ?? "",
            bio: txtViewBio.text,
            email: txtEmail.text ?? "",
            website: txtWeb.text ?? "",
            telephoneNumber: txtNumber.text ?? "",
            address: txtAddress.text ?? "",
            zipCode: txtZip.text ?? "",
            City: txtCity.text ?? "",
            timings: timings
        )
        
        // Firestore collection path
        let collectionPath = "restaurants_Locations/\(UserDefault.token)/locations"
        
        // Query for the document with the matching channel name
        db.collection(collectionPath)
            .whereField("id", isEqualTo: location?.id ?? "")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error finding document: \(error.localizedDescription)")
                    self.stopAnimating()
                } else if let document = querySnapshot?.documents.first {
                    // Document exists, update it
                    db.collection(collectionPath).document(document.documentID).updateData(restaurantLocation.toDictionary()) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            self.stopAnimating()
                            self.showToast(message: "Location successfully updated!", seconds: 2, clr: .gray)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.popup()
                            }
                        }
                    }
                }
            }
    }
    
}
