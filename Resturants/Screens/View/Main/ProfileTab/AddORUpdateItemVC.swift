//
//  AddORUpdateItemVC.swift
//  Resturants
//
//  Created by Coder Crew on 10/08/2024.
//

import UIKit
import Reachability
import FirebaseStorage
import FirebaseFirestoreInternal

class AddORUpdateItemVC: UIViewController {

    @IBOutlet weak var imgItem       : UIImageView!
    @IBOutlet weak var txtName       : UITextField!
    @IBOutlet weak var txtDescrip    : UITextView!
    @IBOutlet weak var txtPrice      : UITextField!
    @IBOutlet weak var txtCurrency   : UITextField!
    @IBOutlet weak var txtMostLiked  : UITextField!
    @IBOutlet weak var txtListNumber : UITextField!
    @IBOutlet weak var txtGroup      : UITextField!
    
    var arr = [1,2,3]
    var id  = ""
    let reachability = try! Reachability()
    var newSelectedImg = ""
    var addNewItem     = false
    let uniqueID = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func ontapSave(_ sender: UIButton){
       addgroupItem()
    }
    
    @IBAction func ontapGetImage(_ sender: UIButton){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate      = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType    = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func ontapCurrency(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtCurrency.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.currencies {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapMostLiked(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtMostLiked.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for i in 1 ... arr.count {
            menuChildren.append(UIAction(title: "\(i)", handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }

    @IBAction func ontapListNumbr(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtListNumber.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for i in 0 ..< arr.count {
            menuChildren.append(UIAction(title: "\(i)", handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapGrp(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtGroup.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for i in 0 ..< arr.count {
            menuChildren.append(UIAction(title: "\(i)", handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
}

extension AddORUpdateItemVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.imgItem.image = pickedImage
            uploadGroupItemImage(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - PostFirebase {}
extension AddORUpdateItemVC {
    
    func uploadGroupItemImage(_ img: UIImage) {
        self.startAnimating()
        if reachability.isReachable {
            let storageRef = Storage.storage().reference().child("groupItem/\(self.uniqueID).png") // Store in "covers" directory
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
                    self.newSelectedImg = "\(downloadURL.absoluteString)"
                }
            }
        } else {
            self.showToast(message: "Internet connection is off.", seconds: 2, clr: .red)
        }
    }
    func addgroupItem() {
        self.startAnimating()
        let db = Firestore.firestore()
        let restaurantLocation = GroupsItemModel(id: self.uniqueID, title: self.txtName.text!, img: self.newSelectedImg, descrip: txtDescrip.text!, price: txtPrice.text!, currency: txtCurrency.text!, mostLiked: txtMostLiked.text!)
        
        let collectionPath = "group_Items/\(self.id)/Items"
        db.collection(collectionPath).addDocument(data: restaurantLocation.toDictionary()) { error in
            if let error = error {
                print("Error saving location: \(error.localizedDescription)")
            } else {
                self.stopAnimating()
                self.popup()
            }
        }
    }
}

