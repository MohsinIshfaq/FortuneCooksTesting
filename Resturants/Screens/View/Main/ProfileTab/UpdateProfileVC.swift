//
//  UpdateProfileVC.swift
//  Resturants
//
//  Created by Coder Crew on 23/04/2024.
//

import UIKit

class UpdateProfileVC: UIViewController , TagPeopleDelegate{
    func reload() {
        collectTagPeople.reloadData()
    }
    
    //MARK: - IBOUtlet
    @IBOutlet weak var txtViewBio       : UITextView!
    @IBOutlet weak var collectTagPeople : UICollectionView!
    @IBOutlet weak var txtChannelNm     : UITextField!
    @IBOutlet weak var txtAddEmail      : UITextField!
    @IBOutlet weak var txtAddWebsite    : UITextField!
    @IBOutlet weak var txtAddPhoneNUmbr : UITextField!
    @IBOutlet weak var txtAddAddressLoc : UITextField!
    @IBOutlet weak var txtZipCode       : UITextField!
    @IBOutlet weak var txtCity          : UITextField!
    @IBOutlet weak var txtAccntType     : UITextField!
    
    @IBOutlet weak var stackMonday      : UIStackView!
    @IBOutlet weak var lblMonday        : UILabel!
    @IBOutlet weak var stackTuesday     : UIStackView!
    @IBOutlet weak var lblTuesday       : UILabel!
    @IBOutlet weak var stackWednesday   : UIStackView!
    @IBOutlet weak var lblWednesday     : UILabel!
    @IBOutlet weak var stackThursday    : UIStackView!
    @IBOutlet weak var lblThursday      : UILabel!
    @IBOutlet weak var stackFriday      : UIStackView!
    @IBOutlet weak var lblFriday        : UILabel!
    @IBOutlet weak var stackSaturday    : UIStackView!
    @IBOutlet weak var lblSaturday      : UILabel!
    @IBOutlet weak var stackSunday      : UIStackView!
    @IBOutlet weak var lblSunday        : UILabel!
    @IBOutlet weak var imgProfile       : UIImageView!
    @IBOutlet weak var imgBig           : UIImageView!
    
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
    
    //MARK: - Variables and Properties
    var activeTextField: UITextField?      = nil
    var selectedHrs                        = ""
    var selectedMins                       = ""
    let placeholder                        = "Enter Bio..."
    let placeholderColor                   = UIColor.lightGray
    var currentImage                       : UIImage!
    var CurrentTagImg                      : Int?
    private var AccntPicker                = UIPickerView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 150))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapAddProfileImg(_ sender: UIButton){
        CurrentTagImg = sender.tag
        pickImg()
    }
    
    @IBAction func ontapAccnt(_ sender: UIButton){
        
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "UpdateMenuVC") as? UpdateMenuVC
        self.navigationController?.pushViewController(vc!, animated: true)
//        let actionClosure = { (action: UIAction) in
//            self.txtAccntType.text = action.title // Update text field with selected option title
//        }
//        var menuChildren: [UIMenuElement] = []
//        for meal in UserManager.shared.arrAccnt {
//            menuChildren.append(UIAction(title: meal, handler: actionClosure))
//        }
//        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
//        sender.showsMenuAsPrimaryAction = true
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
    
    @IBAction func ontapTagPeople(_ sender: UIButton) {
        
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
        vc?.delegate = self
       // vc.showTagUsers
        self.present(vc!, animated: true)
    }
    
    @IBAction func ontapAccountType(_ sender: UIButton){
        
    }
    
    @IBAction func ontapSelectDay(_ sender: UIButton){
        
    }
    
    @IBAction func ontapOpeningtime(_ sender: UIButton){
        
    }
    
    @IBAction func ontapClosingTime(_ sender: UIButton){
        
    }
    
    @IBAction func ontapOpeningMidday(_ sender: UIButton){
        
    }
    
    @IBAction func ontapClosingMidday(_ sender: UIButton){
        
    }
}

//MARK: - Setup Profile {}
extension UpdateProfileVC {
   
    func onload() {
        removeNavBackbuttonTitle()
        txtViewBio.delegate   = self
        setupPlaceholder()
        setupPickerView()
        setupView()
    }
    
    func onAppear() {
    }
    
    func setupPlaceholder() {
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
    
    func setupView() {
        collectTagPeople.register(TagPeopleCCell.nib, forCellWithReuseIdentifier: TagPeopleCCell.identifier)
        collectTagPeople.delegate   = self
        collectTagPeople.dataSource = self
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
extension UpdateProfileVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

//MARK: - Collection View Setup {}
extension UpdateProfileVC: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.totalTagPeople
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPeopleCCell.identifier, for: indexPath) as! TagPeopleCCell
        cell.btnDismiss.addTarget(self, action: #selector(removeTapped(sender:)), for: .touchUpInside)
        cell.btnDismiss.tag = indexPath.row
        
        return cell
    }
    
    @objc func removeTapped(sender: UIButton) {
        if UserManager.shared.arrTagPeoples[sender.tag][1] == "0" {
            UserManager.shared.arrTagPeoples[sender.tag][1] = "1"
            UserManager.shared.totalTagPeople += 1
            print(UserManager.shared.totalTagPeople)
        }
        else{
            UserManager.shared.arrTagPeoples[sender.tag][1] = "0"
            UserManager.shared.totalTagPeople -= 1
        }
        collectTagPeople.reloadData()
    }
}

// MARK: - UITextViewDelegate {}
extension UpdateProfileVC : UITextViewDelegate{
    
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

//MARK: - Protocol Image Picker {}
extension UpdateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickImg() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        currentImage = image
        if CurrentTagImg == 0 {
            imgProfile.image = currentImage
        }
        else {
            imgBig.image     = currentImage
        }
    }
}

//MARK: - Picker View for Schedule Selection {}
extension UpdateProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
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
