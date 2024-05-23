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
protocol ReloadDelegate {
    func reload(img : UIImage?)
}

class UplaodSwiftVC: UIViewController , ReloadDelegate , UITextViewDelegate , createAccntDelegate , TagPeopleDelegate, UITextFieldDelegate{
    
    func reload() {
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
        self.uplaodThumbnail(image)
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
    
    //MARK: - Variables and Properties
    private var outputURL: URL?            = nil
    let placeholder                        = "Enter your text here..."
    let placeholderColor                   = UIColor.lightGray
    var arrSelectedContent  : [String]     = []
    var arrHastag           : [String]     = []
    var thumbnailURL        : URL?         = nil
    let storage = Storage.storage().reference()
    
    lazy var UploadVideoModel              : [String: Any] =  {
        return ["address": txtAddress.text! as String  ,
                "Zipcode": txtZipCode.text! as String  ,
                "city"   : txtCity.text! as String     ,
                "hashTagsModelList": arrHastag         ,
                "Title":   txtTitle.text! as String    ,
                "description": txtView.text! as String ,
                "categories": arrSelectedContent       ,
                "language": txtLang.text! as String    ,
                "ThumbnailUrl": "\(thumbnailURL)"      ,
                "videoUrl"    : ""]
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
        
            let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "UploadSwift2VC") as! UploadSwift2VC
            vc.UploadVideoModel = self.UploadVideoModel
            print(UploadVideoModel)
            self.navigationController?.pushViewController(vc, animated: true)
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
}

extension UplaodSwiftVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
}
//MARK: - Collection View Setup {}
extension UplaodSwiftVC: UICollectionViewDelegate , UICollectionViewDataSource {
    
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
            return UserManager.shared.totalTagPeople
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
}

//MARK: - Uplaod Thumbnail {}
extension UplaodSwiftVC {
    
    func uplaodThumbnail(_ img: UIImage) {
        self.startAnimating()
        let storageRef = Storage.storage().reference().child("MyImg.png")
        let imgData = img.pngData()
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        storageRef.putData(imgData!,metadata: metadata) { metadata, error in
            self.stopAnimating()
            if error == nil {
                let storage = Storage.storage().reference(withPath: "MyImg.png")
                storage.downloadURL { (url, error) in
                    if error != nil {
                        self.stopAnimating()
                        print((error?.localizedDescription)!)
                        return
                    }
                    self.stopAnimating()
                    print("Download success")
                    //url = your will get an image URL
                    var DownlodedURL  = url!
                    self.thumbnailURL = DownlodedURL
                }
            }
        }
    }
}
