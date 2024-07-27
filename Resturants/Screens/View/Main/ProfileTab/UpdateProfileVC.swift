//
//  UpdateProfileVC.swift
//  Resturants
//
//  Created by Coder Crew on 23/04/2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestoreInternal
import Reachability

struct Tags {
    let uid: String?
    let img: String?
    let channelName: String?
    let followers: String?
    let accountType: String?
}

class UpdateProfileVC: UIViewController , TagPeopleDelegate{
 
    func reload(data: [UserTagModel]) {
        profileModel?.tagPersons?.removeAll()
       // popRoot()
        for i in data {
            profileModel?.tagPersons?.append(TagUsers(uid: i.uid ?? "", img: i.img ?? "", channelName: i.channelName ?? "", followers: i.followers ?? "", accountType: i.accountType ?? ""))
        }
        collectTagPeople.reloadData()
    }
    
//    func reload() {
//        collectTagPeople.reloadData()
//    }
    
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
    @IBOutlet weak var lblChanlNm       : UILabel!
    
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
    @IBOutlet weak var lblAccntType     : UILabel!
    @IBOutlet weak var lblFollowers     : UILabel!
    
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
    @IBOutlet weak var stackTimings        : UIStackView!
    
    @IBOutlet weak var switchMonday        : UISwitch!
    @IBOutlet weak var switchTuesday       : UISwitch!
    @IBOutlet weak var switchWednesday     : UISwitch!
    @IBOutlet weak var switchThrusday      : UISwitch!
    @IBOutlet weak var switchFriday        : UISwitch!
    @IBOutlet weak var switchSaturday      : UISwitch!
    @IBOutlet weak var switchSunday        : UISwitch!
    
    //MARK: - Variables and Properties
    var activeTextField: UITextField?      = nil
    var selectedHrs                        = "00"
    var selectedMins                       = "00"
    let placeholder                        = "Enter Bio..."
    let placeholderColor                   = UIColor.lightGray
    var currentImage                       : UIImage!
    var CurrentTagImg                      : Int?
    private var AccntPicker                = UIPickerView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 150))
    var profileModel                       : UserProfileModel? = nil
    let reachability                       = try! Reachability()
    
    
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
        vc?.profileModel = self.profileModel
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func ontapSave(_ sender: UIButton){
        if validateFields(email: txtAddEmail.text, web: txtAddWebsite.text) {
            addProfile(UserDefault.token)
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
    
    @IBAction func ontapTagPeople(_ sender: UIButton) {
        
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
        vc?.delegate        = self
        vc?.showTagUsers    = false
        vc?.blockUsers      = profileModel?.blockUsers ?? []
        vc?.alreadyTagUsers = profileModel?.tagPersons ?? []
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
        setupUserData()
    }
    
    func validateFields(email: String?, web: String?) -> Bool  {
        if let email = email, !email.isEmpty {
            guard "".isValidEmailRegex(email) else {
                self.showToast(message: "Email is not valid", seconds: 2, clr: .red)
                print("Invalid email address")
                return false
            }
        }
        
        if let web = web, !web.isEmpty {
            guard "".isValidWebsite(url: web) else {
                self.showToast(message: "web URL is not valid", seconds: 2, clr: .red)
                return false
            }
        }
        
        return true
    }
    
    func setupUserData(){
       
        if let profile = self.profileModel {
            
            DispatchQueue.main.async {
                if let coverURL = profile.coverUrl, let urlCover1 = URL(string: coverURL) {
                    self.imgBig.sd_setImage(with: urlCover1)
                }
            }
            DispatchQueue.main.async {
                if let profileURL = profile.profileUrl, let urlProfile1 = URL(string: profileURL) {
                    self.imgProfile.sd_setImage(with: urlProfile1)
                }
            }
            txtAccntType.text     = profile.accountType ?? ""
            txtChannelNm.text     = profile.channelName ?? ""
            txtViewBio.text       = profile.bio ?? ""
            txtAddEmail.text      = profile.businessEmail ?? ""
            txtAddWebsite.text    = profile.website ?? ""
            txtAddPhoneNUmbr.text = profile.businessphoneNumber ?? ""
            txtAddAddressLoc.text = profile.address ?? ""
            txtZipCode.text       = profile.zipcode ?? ""
            txtCity.text          = profile.city ?? ""
            lblAccntType.text     = "(\(profile.accountType ?? ""))"
            lblFollowers.text     = "\(profile.followers?.count ?? 0) Followers"
            lblChanlNm.text       = profile.channelName ?? ""
            
            if profile.accountType == "Private person" || profile.accountType == "Content Creator" {
                stackTimings.isHidden = true
            }
            else{
                stackTimings.isHidden = false
            }
            
            if !(profile.timings?.isEmpty ?? false){
                txtMondayOpening.text    = profile.timings?[0] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[0] ?? "")?.0
                txtMondayClosing.text    = profile.timings?[0] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[0] ?? "")?.1
                lblMonday.isHidden    = profile.timings?[0] == "Closed" ? false : true
                stackMonday.isHidden  = profile.timings?[0] == "Closed" ? true : false
                switchMonday.isOn     = profile.timings?[0] == "Closed" ? false : true
                
                txtTuesdayOpening.text   = profile.timings?[1] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[1] ?? "")?.0
                txtTuesdayClosing.text   = profile.timings?[1] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[1] ?? "")?.1
                lblTuesday.isHidden   = profile.timings?[1] == "Closed" ? false : true
                stackTuesday.isHidden = profile.timings?[1] == "Closed" ? true : false
                switchTuesday.isOn    = profile.timings?[1] == "Closed" ? false : true
                
                txtWednesdayOpening.text = profile.timings?[2] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[2] ?? "")?.0
                txtWednesdayClosing.text = profile.timings?[2] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[2] ?? "")?.1
                lblWednesday.isHidden   = profile.timings?[2] == "Closed" ? false : true
                stackWednesday.isHidden = profile.timings?[2] == "Closed" ? true : false
                switchWednesday.isOn    = profile.timings?[2] == "Closed" ? false : true
                
                txtThrusdayOpening.text  = profile.timings?[3] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[3] ?? "")?.0
                txtThrusdayClosing.text  = profile.timings?[3] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[3] ?? "")?.1
                lblThursday.isHidden   = profile.timings?[3] == "Closed" ? false : true
                stackThursday.isHidden = profile.timings?[3] == "Closed" ? true : false
                switchThrusday.isOn    = profile.timings?[3] == "Closed" ? false : true
                
                txtFridayOpening.text    = profile.timings?[4] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[4] ?? "")?.0
                txtFridayClosing.text    = profile.timings?[4] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[4] ?? "")?.1
                lblFriday.isHidden   = profile.timings?[4] == "Closed" ? false : true
                stackFriday.isHidden = profile.timings?[4] == "Closed" ? true : false
                switchFriday.isOn    = profile.timings?[4] == "Closed" ? false : true
                
                txtSaturdayOpening.text  = profile.timings?[5] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[5] ?? "")?.0
                txtSaturdayClosing.text  = profile.timings?[5] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[5] ?? "")?.1
                lblSaturday.isHidden   = profile.timings?[5] == "Closed" ? false : true
                stackSaturday.isHidden = profile.timings?[5] == "Closed" ? true : false
                switchSaturday.isOn    = profile.timings?[5] == "Closed" ? false : true
                
                
                txtSundayOpening.text    = profile.timings?[6] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[6] ?? "")?.0
                txtSundayClosing.text    = profile.timings?[6] == "Closed" ? "0:0" : splitTimeRange(profile.timings?[6] ?? "")?.1
                lblSunday.isHidden   = profile.timings?[6] == "Closed" ? false : true
                stackSunday.isHidden = profile.timings?[6] == "Closed" ? true : false
                switchSunday.isOn    = profile.timings?[6] == "Closed" ? false : true
            }
            collectTagPeople.reloadData()
        }
    }
    
    func updateCoverUrlInModel(newCoverUrl: String) {
        if var model = self.profileModel {
            model.coverUrl = newCoverUrl
            self.profileModel = model
            setupUserData()
        }
    }
    
    func updateProfileUrlInModel(newProfileUrl: String) {
        if var model = self.profileModel {
            model.profileUrl = newProfileUrl
            self.profileModel = model
            setupUserData()
        }
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
    
    func splitTimeRange(_ timeRange: String) -> (String, String)? {
        let components = timeRange.split(separator: "-")
        guard components.count == 2 else { return nil }
        let startTime = String(components[0])
        let endTime = String(components[1])
        return (startTime, endTime)
    }
    
    func getMondaySchedule(_ opening: String,  _ closing: String , switchs: Bool) -> String {
        //MARK: - if switch is hide it means schedule is closed like monday is closed
        return switchs ? "\(opening) - \(closing)" : "Closed"
    }
    
    func updateProfileModel(channel: String , bio: String , businessEmail: String , web: String , businessNumber: String , address: String , zipCode: String , city: String , timings: [String]) {
        if var model = self.profileModel {
            print(model)
            updateUserDocument(img: model.profileUrl ?? ""  , channelNm: channel, followers: model.followers?.count ?? 0 , acountType: model.accountType ?? "")
            model.channelName         = channel
            model.bio                 = bio
            model.businessEmail       = businessEmail
            model.website             = web
            model.businessphoneNumber = businessNumber
            model.address             = address
            model.zipcode             = zipCode
            model.city                = city
            model.timings             = timings
            self.profileModel         = model
            popRoot()
        }
    }
}

//MARK: -  Extend the class to conform to UITextFieldDelegate
extension UpdateProfileVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField?.text = "\(selectedHrs) : \(selectedMins)"
        activeTextField = nil
        
    }
}

//MARK: - Collection View Setup {}
extension UpdateProfileVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(profileModel?.tagPersons?.count ?? 0)
        return profileModel?.tagPersons?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPeopleCCell.identifier, for: indexPath) as! TagPeopleCCell
        if let users = profileModel?.tagPersons?[indexPath.row]{
            if let userURL = users.img, let urlUser1 = URL(string: userURL) {
                cell.img.sd_setImage(with: urlUser1)
            }
            cell.lbl.text = users.channelName ?? ""
            cell.btnDismiss.addTarget(self, action: #selector(removeTapped(sender:)), for: .touchUpInside)
            cell.btnDismiss.tag = indexPath.row
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPeopleCCell.identifier, for: indexPath) as! TagPeopleCCell
        if let users = profileModel?.tagPersons?[indexPath.row]{
            cell.lbl.text = users.channelName ?? ""
        }
        let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)
        let fittingSize = cell.contentView.systemLayoutSizeFitting(targetSize,
                                                                       withHorizontalFittingPriority: .fittingSizeLevel,
                                                                       verticalFittingPriority: .required)
        return CGSize(width: fittingSize.width, height: 30)
    }
    
    
    @objc func removeTapped(sender: UIButton) {
        profileModel?.tagPersons?.remove(at: sender.tag)
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
            uploadProfileImg(currentImage, userID: UserDefault.token)
           
        }
        else {
            imgBig.image   = currentImage
            uploadCoverImg(currentImage, userID: UserDefault.token)
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
//MARK: - API'S
extension UpdateProfileVC {
    func uploadCoverImg(_ img: UIImage, userID: String) {
        self.startAnimating()
        if reachability.isReachable {
            let uniqueID = UUID().uuidString
            let storageRef = Storage.storage().reference().child("covers/\(uniqueID).png") // Store in "covers" directory
            guard let imgData = img.pngData() else {
                self.stopAnimating()
                print("Error: Could not convert image to PNG data")
                return
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            storageRef.putData(imgData, metadata: metadata) { metadata, error in
                self.stopAnimating() // Stop animating when upload is finished
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                // Successfully uploaded the image
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let downloadURL = url else {
                        print("Error: Download URL is nil")
                        return
                    }
                    
                    print("Download success, URL: \(downloadURL.absoluteString)")
                    // Update the user's coverUrl in Firestore
                    let db = Firestore.firestore()
                    db.collection("Users").document(userID).updateData([
                        "coverUrl": downloadURL.absoluteString
                    ]) { err in
                        if let err = err {
                            print("Error updating coverUrl: \(err)")
                        } else {
                            print("Cover URL successfully updated in Firestore")
                            self.updateCoverUrlInModel(newCoverUrl: downloadURL.absoluteString)
                        }
                    }
                }
            }
        } else {
            self.showToast(message: "Internet connection is off.", seconds: 2, clr: .red)
        }
    }
    func uploadProfileImg(_ img: UIImage, userID: String) {
        self.startAnimating()
        if reachability.isReachable {
            let uniqueID = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profiles/\(uniqueID).png") // Store in "covers" directory
            guard let imgData = img.pngData() else {
                self.stopAnimating()
                print("Error: Could not convert image to PNG data")
                return
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            storageRef.putData(imgData, metadata: metadata) { metadata, error in
                self.stopAnimating() // Stop animating when upload is finished
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                // Successfully uploaded the image
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let downloadURL = url else {
                        print("Error: Download URL is nil")
                        return
                    }
                    
                    print("Download success, URL: \(downloadURL.absoluteString)")
                    // Update the user's coverUrl in Firestore
                    let db = Firestore.firestore()
                    db.collection("Users").document(userID).updateData([
                        "profileUrl": downloadURL.absoluteString
                    ]) { err in
                        if let err = err {
                            print("Error updating coverUrl: \(err)")
                        } else {
                            print("Cover URL successfully updated in Firestore")
                            self.updateProfileUrlInModel(newProfileUrl: downloadURL.absoluteString)
                        }
                    }
                }
            }
        } else {
            self.showToast(message: "Internet connection is off.", seconds: 2, clr: .red)
        }
    }
    func addProfile(_ userID: String) {
        self.startAnimating()
        var monday = lblMonday.isHidden ? "\(txtMondayOpening.text!) : \(txtMondayClosing.text!)" : "Closed"
        var timings = [getMondaySchedule(txtMondayOpening.text ?? "", txtMondayClosing.text!, switchs: lblMonday.isHidden) ,
                       getMondaySchedule(txtTuesdayOpening.text ?? "", txtTuesdayClosing.text!, switchs: lblTuesday.isHidden) ,
                       getMondaySchedule(txtWednesdayOpening.text ?? "", txtWednesdayClosing.text!, switchs: lblWednesday.isHidden) ,
                       getMondaySchedule(txtThrusdayOpening.text ?? "", txtThrusdayClosing.text!, switchs: lblThursday.isHidden) ,
                       getMondaySchedule(txtFridayOpening.text ?? "", txtFridayClosing.text!, switchs: lblFriday.isHidden) ,
                       getMondaySchedule(txtSaturdayOpening.text ?? "", txtSaturdayClosing.text!, switchs: lblSaturday.isHidden) ,
                       getMondaySchedule(txtSundayOpening.text ?? "", txtSundayClosing.text!, switchs: lblSunday.isHidden)]
        print(timings)
        let db = Firestore.firestore()
        var tagUsersArray: [[String: Any]] = []

        if let tagPersons = profileModel?.tagPersons {
            for person in tagPersons {
                var userDict: [String: Any] = [:]
                userDict["uid"] = person.uid
                userDict["img"] = person.img
                userDict["channelName"] = person.channelName
                userDict["followers"] = person.followers
                userDict["accountType"] = person.accountType
                tagUsersArray.append(userDict)
            }
        }
        db.collection("Users").document(userID).updateData([
            "channelName": txtChannelNm.text! ,
            "bio": txtViewBio.text!,
            "businessEmail": txtAddEmail.text! ,
            "tagPersons": tagUsersArray ,
            "website": txtAddWebsite.text! ,
            "businessNumber": txtAddPhoneNUmbr.text! ,
            "address": txtAddAddressLoc.text! ,
            "zipcode": txtZipCode.text! ,
            "city": txtCity.text! ,
            "timings": timings
        ]) { err in
            if let err = err {
                self.stopAnimating()
                print("Error updating coverUrl: \(err)")
            } else {
                self.stopAnimating()
                print("Cover URL successfully updated in Firestore")
                self.updateProfileModel(channel:  self.txtChannelNm.text!, bio: self.txtViewBio.text!, businessEmail: self.txtAddEmail.text!, web: self.txtAddWebsite.text!, businessNumber: self.txtAddPhoneNUmbr.text!, address: self.txtAddAddressLoc.text!, zipCode: self.txtZipCode.text!, city: self.txtCity.text!, timings: timings)
            }
        }
    }
    //update user in userCollection for data should be updated everytime. if user change profile
    func updateUserDocument(img: String  , channelNm: String , followers: Int , acountType: String) {
        let db = Firestore.firestore()
        let userToken = UserDefault.token
        
        db.collection("userCollection").whereField("uid", isEqualTo: userToken).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let documentID = document.documentID
                    // New data to update the document
                    let updatedData: [String: Any] = [
                        "img": img,
                        "channelName": channelNm,
                        "followers": followers,
                        "accountType": acountType
                    ]
                    db.collection("userCollection").document(documentID).updateData(updatedData) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
        }
    }
    
}
