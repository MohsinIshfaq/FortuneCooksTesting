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
    
    //MARK: - Variables and Properties
    var activeTextField: UITextField?      = nil
    var selectedHrs                        = ""
    var selectedMins                       = ""
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
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func ontapSave(_ sender: UIButton){
        addProfile(UserDefault.token)
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
        setupUserData()
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
            txtChannelNm.text     = profile.channelName ?? ""
            txtViewBio.text       = profile.bio ?? ""
            txtAddEmail.text      = profile.email ?? ""
            txtAddWebsite.text    = profile.website ?? ""
            txtAddPhoneNUmbr.text = profile.phoneNumber ?? ""
            txtAddAddressLoc.text = profile.address ?? ""
            txtZipCode.text       = profile.zipcode ?? ""
            txtCity.text          = profile.city ?? ""
            lblAccntType.text     = profile.accountType ?? ""
            lblFollowers.text     = "\(profile.followers?.count ?? 0) Followers"
            
            if !(profile.timings?.isEmpty ?? false){
                txtMondayOpening.text    = profile.timings?[0] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[0] ?? "")?.0
                txtMondayClosing.text    = profile.timings?[0] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[0] ?? "")?.1
                
                txtTuesdayOpening.text   = profile.timings?[1] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[1] ?? "")?.0
                txtTuesdayClosing.text   = profile.timings?[1] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[1] ?? "")?.1
                
                txtWednesdayOpening.text = profile.timings?[2] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[2] ?? "")?.0
                txtWednesdayClosing.text = profile.timings?[2] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[2] ?? "")?.1
                
                txtThrusdayOpening.text  = profile.timings?[3] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[3] ?? "")?.0
                txtThrusdayClosing.text  = profile.timings?[3] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[3] ?? "")?.1
                
                txtFridayOpening.text    = profile.timings?[4] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[4] ?? "")?.0
                txtFridayClosing.text    = profile.timings?[4] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[4] ?? "")?.1
                
                txtSaturdayOpening.text  = profile.timings?[5] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[5] ?? "")?.0
                txtSaturdayClosing.text  = profile.timings?[5] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[5] ?? "")?.1
                
                txtSundayOpening.text    = profile.timings?[6] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[6] ?? "")?.0
                txtSundayClosing.text    = profile.timings?[6] == "Closed" ? "Closed" : splitTimeRange(profile.timings?[6] ?? "")?.1
            }
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
        return switchs ? "\(txtMondayOpening.text!) : \(txtMondayClosing.text!)" : "Closed"
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
        var monday = lblMonday.isHidden == false ? "\(txtMondayOpening.text!) : \(txtMondayClosing.text!)" : "Closed"
        var timings = [getMondaySchedule(txtMondayOpening.text ?? "", txtMondayClosing.text!, switchs: lblMonday.isHidden) ,
                       getMondaySchedule(txtTuesdayOpening.text ?? "", txtTuesdayClosing.text!, switchs: lblTuesday.isHidden) ,
                       getMondaySchedule(txtWednesdayOpening.text ?? "", txtWednesdayClosing.text!, switchs: lblWednesday.isHidden) ,
                       getMondaySchedule(txtThrusdayOpening.text ?? "", txtThrusdayClosing.text!, switchs: lblThursday.isHidden) ,
                       getMondaySchedule(txtFridayOpening.text ?? "", txtFridayClosing.text!, switchs: lblFriday.isHidden) ,
                       getMondaySchedule(txtSaturdayOpening.text ?? "", txtSaturdayClosing.text!, switchs: lblSaturday.isHidden) ,
                       getMondaySchedule(txtSundayOpening.text ?? "", txtSundayClosing.text!, switchs: lblSunday.isHidden)]
        print(timings)
        let db = Firestore.firestore()
        db.collection("Users").document(userID).updateData([
            "accountType": txtAccntType.text! ,
            "bio": txtViewBio.text!,
            "email": txtAddEmail.text! ,
            "website": txtAddWebsite.text! ,
            "phoneNumber": txtAddPhoneNUmbr.text! ,
            "address": txtAddAddressLoc.text! ,
            "zipcode": txtZipCode.text! ,
            "city": txtCity.text! ,
            "timings": timings
        ]) { err in
            if let err = err {
                print("Error updating coverUrl: \(err)")
            } else {
                print("Cover URL successfully updated in Firestore")
                //self.updateCoverUrlInModel(bio: self.txtViewBio.text!)
            }
        }
    }
}
