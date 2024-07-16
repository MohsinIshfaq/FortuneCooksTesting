//
//  UplaodSwiftVC.swift
//  Resturants
//
//  Created by Coder Crew on 27/03/2024.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit
import FirebaseStorage
import Reachability

protocol ReloadDelegate {
    func reload(img : UIImage?)
}

class UplaodSwiftVC: UIViewController , ReloadDelegate , UITextViewDelegate , createAccntDelegate , TagPeopleDelegate, UITextFieldDelegate{
    func reload(data: [UserTagModel]) {
        selectedTagPersons = data
        collectTagPeople.reloadData()
    }
    func collectionData(type: Int) {
        UserManager.shared.selectedCuisine.removeAll()
        arrSelectedContent.removeAll()
        for i in 0..<UserManager.shared.arrContent.count{
            if UserManager.shared.arrContent[i][1] == "1" {
                self.arrSelectedContent.append(UserManager.shared.arrContent[i][0])
            }
        }
        collectContent.reloadData()
    }
    func reload(img: UIImage?) {
        imgThumbnail.image = img
        guard let image = imgThumbnail.image else {
            print("Error: imgThumbnail.image is nil")
            return
        }
        DispatchQueue.global(qos: .background).async {
            self.uplaodThumbnail(image)
        }
    }
    
    //MARK: - IBOUtlets
    @IBOutlet weak var txtAddress : UITextField!
    @IBOutlet weak var txtZipCode : UITextField!
    @IBOutlet weak var txtCity    : UITextField!
    @IBOutlet weak var txtTagPeople : UITextField!
    @IBOutlet weak var txtTitle   : UITextField!
    @IBOutlet weak var txtHastag  : UITextField!
    @IBOutlet weak var txtLang    : UITextField!
    @IBOutlet weak var btnThumbnail  : UIButton!
    @IBOutlet weak var imgThumbnail  : UIImageView!
    @IBOutlet weak var imgVideoThumb : UIImageView!
    @IBOutlet weak var txtView       : UITextView!
    @IBOutlet weak var btnContent    : UIButton!
    @IBOutlet weak var btnTopContent : UIButton!
    @IBOutlet weak var collectContent: UICollectionView!
    @IBOutlet weak var collectHastag : UICollectionView!
    @IBOutlet weak var lblhastag     : UILabel!
    @IBOutlet weak var collectTagPeople : UICollectionView!
    @IBOutlet weak var btnAddHastag  : UIButton!
    @IBOutlet weak var stackDescrip  : UIStackView!
    
    //MARK: - Variables and Properties
    private var outputURL: URL?            = nil
    let placeholder                        = "Enter your text here..."
    let placeholderColor                   = UIColor.lightGray
    var arrSelectedContent  : [String]     = []
    var arrHastag           : [String]     = []
    var thumbnailURL        : URL?         = nil
    let storage = Storage.storage().reference()
    var gotSelectedThumbnail: Bool         = false
    let reachability = try! Reachability()
    var selectedTagPersons: [UserTagModel]? = nil
    var isVideoPicked: Bool                 = false    //checking video picked or recorded to handle description
    
    lazy var UploadVideoModel              : [String: Any] =  {
        return [
            "uid": UserDefault.token as String  ,
            "address": txtAddress.text! as String  ,
            "zipcode": txtZipCode.text! as String  ,
            "city"   : txtCity.text! as String     ,
            "title":   txtTitle.text! as String    ,
            "tagPersons": self.selectedTagPersons! as [UserTagModel],
            "description": txtView.text! as String ,
            "categories": arrSelectedContent       ,
            "hashtages": arrHastag         ,
            "language": txtLang.text! as String    ,
            "thumbnailUrl": "\(thumbnailURL!)"     ,
            "videoUrl"    : ""                     ,
            "Likes"       : false                  ,
            "comments"    : false                  ,
            "views"       : false                  ,
            "paidCollab"  : false                  ,
            "introVideos" : false                  ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapAddContent(_ sender: UIButton){
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "ContentSelectionVC") as! ContentSelectionVC
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func ontapPickVideo(_ sender: UIButton){
        DispatchQueue.main.async {
            if let url = UserManager.shared.finalURL {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
    @IBAction func ontapTagPeople(_ sender: UIButton) {
        
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
        vc?.delegate = self
        vc?.showTagUsers = false
        self.present(vc!, animated: true)
    }
    @IBAction func ontapThumbnail(_ sender: UIButton){
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "UploadThumbnailVC") as? UploadThumbnailVC
        vc?.delegate  = self
        self.present(vc!, animated: true)
    }
    @IBAction func ontapAddHastag(_ sender : UIButton) {
        
        if txtHastag.text             != "" {
            if arrHastag.count        <= 10 {
                let stringWithoutSpaces = txtHastag.text!.replacingOccurrences(of: " ", with: "")
                arrHastag.append("#\(stringWithoutSpaces)")
                collectHastag.reloadData()
                txtHastag.text        = ""
                btnAddHastag.isHidden = true
            }
        }
    }
    @IBAction func ontapLang(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtLang.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.arrlanguages {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    @IBAction func ontapNext(_ sender: UIButton){
        if checkFields() == "" {
            let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "UploadSwift2VC") as! UploadSwift2VC
            vc.UploadVideoModel = self.UploadVideoModel
            print(UploadVideoModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.showToast(message: checkFields(), seconds: 2, clr: .red)
        }
    }
}

//MARK: - Extension of setup Data{}
extension UplaodSwiftVC {
    func onLoad() {
        removeNavBackbuttonTitle()
        if let url = UserManager.shared.finalURL {
            if let img = generateThumbnail(path: url) {
                self.imgVideoThumb.image  = img
            }
        }
        txtView.delegate   = self
        txtHastag.delegate = self
        setupPlaceholder()
        setupViews()
        
        if isVideoPicked {
            stackDescrip.isHidden = false
        }
        else{
            stackDescrip.isHidden = true
        }
    }
    
    func onAppear() {
        self.showNavBar()
    }
    
    func setupPlaceholder() {
        txtView.text = placeholder
        txtView.textColor = placeholderColor
    }
    
    func setupViews() {
        collectContent.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        collectContent.delegate      = self
        collectContent.dataSource    = self
        
        collectHastag.register(HastagCCell.nib, forCellWithReuseIdentifier: HastagCCell.identifier)
        collectHastag.delegate      = self
        collectHastag.dataSource    = self
        
        collectTagPeople.register(TagPeopleCCell.nib, forCellWithReuseIdentifier: TagPeopleCCell.identifier)
        collectTagPeople.delegate   = self
        collectTagPeople.dataSource = self
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = txtHastag.text, !text.isEmpty {
            // TextField is not empty
            btnAddHastag.isHidden = false
        } else {
            // TextField is empty
            print("TextField is empty")
            btnAddHastag.isHidden = true
        }
    }
    
    func checkFields() -> String {
        
        if !gotSelectedThumbnail {
            return "Thumbnail is not selected."
        }
//         if txtAddress.text == "" {
//            return "Field Address shouldn't empty."
//        }
//        else if txtZipCode.text == "" {
//            return "Field ZipCode shouldn't empty."
//        }
//        else if txtCity.text == "" {
//            return "Field city shouldn't empty."
//        }
        else if txtTitle.text == "" {
            return "Field Title shouldn't empty."
        }
        else if txtView.text == "" {
            return "Field city shouldn't empty."
        }
//        else if UserManager.shared.selectedContent.count == 0 {
//            return "Content is not added."
//        }
//        else if arrHastag.count == 0 {
//            return "Hastag is not added."
//        }
        else if txtLang.text == "" {
            return "Field Language shouldn't empty."
        }
        return ""
    }
}

extension UplaodSwiftVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
}
//MARK: - Collection View Setup {}
extension UplaodSwiftVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectContent {
            if arrSelectedContent.count == 0 {
                self.btnContent.isHidden = false
                self.btnTopContent.isHidden = true
                return 0
            }
            else{
                self.btnContent.isHidden = true
                self.btnTopContent.isHidden = false
                return arrSelectedContent.count
            }
        }
        else if collectionView == collectTagPeople {
            return selectedTagPersons?.count ?? 0
        }
        else{
            lblhastag.text = "\(arrHastag.count)/10"
            return arrHastag.count
        }
    }
    
    @objc func onTapCon(sender: UIButton){
        for i in 0..<UserManager.shared.arrContent.count{
            if UserManager.shared.arrContent[i][0] == arrSelectedContent[sender.tag] {
                UserManager.shared.arrContent[i][1]  = "0"
            }
        }
        UserManager.shared.selectedContent.removeAll()
        arrSelectedContent.remove(at: sender.tag)
        collectContent.reloadData()
    }
    
    @objc func onTapHastag(sender: UIButton){
        
        arrHastag.remove(at: sender.tag)
        collectHastag.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectContent {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            
            cell.lbl.text = arrSelectedContent[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapCon(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedContent.append(arrSelectedContent[indexPath.row])
            return cell
        }
        else if collectionView == collectTagPeople {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPeopleCCell.identifier, for: indexPath) as! TagPeopleCCell
            DispatchQueue.main.async {
                if let profileURL = self.selectedTagPersons?[indexPath.row].img, let urlProfile1 = URL(string: profileURL) {
                    cell.img.sd_setImage(with: urlProfile1)
                }
                cell.lbl.text      = self.selectedTagPersons?[indexPath.row].channelName ?? ""
            }
            cell.btnDismiss.addTarget(self, action: #selector(removeTapped(sender:)), for: .touchUpInside)
            cell.btnDismiss.tag = indexPath.row
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HastagCCell.identifier, for: indexPath) as! HastagCCell
            cell.lbl.text  = arrHastag[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapHastag(sender:)), for: .touchUpInside)
            cell.btn.tag   = indexPath.row
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectTagPeople {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPeopleCCell.identifier, for: indexPath) as! TagPeopleCCell
            if let users = self.selectedTagPersons?[indexPath.row]{
                cell.lbl.text = users.channelName ?? ""
            }
            let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)
            let fittingSize = cell.contentView.systemLayoutSizeFitting(targetSize,
                                                                       withHorizontalFittingPriority: .fittingSizeLevel,
                                                                       verticalFittingPriority: .required)
            return CGSize(width: fittingSize.width, height: 30)
        }
        else if collectionView == collectContent {
            return CGSize(width: 110, height: 40)
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HastagCCell.identifier, for: indexPath) as! HastagCCell
            cell.lbl.text  = arrHastag[indexPath.row]
            let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)
            let fittingSize = cell.contentView.systemLayoutSizeFitting(targetSize,
                                                                       withHorizontalFittingPriority: .fittingSizeLevel,
                                                                       verticalFittingPriority: .required)
            return CGSize(width: fittingSize.width, height: 30)
        }
    }
    
    @objc func removeTapped(sender: UIButton) {
        self.selectedTagPersons?.remove(at: sender.tag)
        collectTagPeople.reloadData()
    }
}

//MARK: - Uplaod Thumbnail {}
extension UplaodSwiftVC {
    
    func uplaodThumbnail(_ img: UIImage) {
        // self.startAnimating()
        if reachability.isReachable {
            let uniqueID = UUID().uuidString
            print(uniqueID)
            let storageRef = Storage.storage().reference().child("thumbnails/\(uniqueID).png")
            let imgData = img.pngData()
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            storageRef.putData(imgData!,metadata: metadata) { metadata, error in
                //  self.stopAnimating()
                if error == nil {
                    let storage = storageRef
                    storage.downloadURL { (url, error) in
                        if error != nil {
                            self.stopAnimating()
                            print((error?.localizedDescription)!)
                            return
                        }
                        //  self.stopAnimating()
                        print("Download success")
                        //url = your will get an image URL
                        var DownlodedURL  = url!
                        self.thumbnailURL = DownlodedURL
                        self.gotSelectedThumbnail = true
                    }
                }
            }
        }
        else{
            self.showToast(message: "Internet connection is off.", seconds: 2, clr: .red)
        }
    }
}
