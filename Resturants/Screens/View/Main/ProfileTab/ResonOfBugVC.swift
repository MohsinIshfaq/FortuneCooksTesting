//
//  ResonOfBugVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/06/2024.
//

import UIKit
import FirebaseFirestoreInternal
import Reachability
import FirebaseStorage

class ResonOfBugVC: UIViewController {

    @IBOutlet weak var lblHeader        : UILabel!
    @IBOutlet weak var txtViewBio       : UITextView!
    @IBOutlet weak var imgAttach        : UIImageView!
    
    let placeholder                        = "Enter Here..."
    let placeholderColor                   = UIColor.lightGray
    var tag = 0
    let reachability = try! Reachability()
    var downloadedURL                      = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onload()
    }

    @IBAction func ontapAddAttachement(_ sender: UIButton) {
        pickImg()
    }
    
    @IBAction func ontapSend(_ sender: UIButton) {
        saveFeedBack()
    }
}

//MARK: - Setup Profile {}
extension ResonOfBugVC {
   
    func onload() {
      
        if tag == 0{
            self.navigationItem.title = "Bug"
            lblHeader.text = "Clarify describe where the bug is on the platform be detailed."
        }
        else{
            self.navigationItem.title = "Suggestions"
            lblHeader.text = "How can we make fortune cooks better."
        }
        removeNavBackbuttonTitle()
        setupPlaceholder()
    }
    
    func onAppear() {
        hidesBottomBarWhenPushed = false
    }
    
    func setupPlaceholder() {
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
}


// MARK: - UITextViewDelegate {}
extension ResonOfBugVC : UITextViewDelegate{
    
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

//MARK: - Get Attachment URL {}
extension ResonOfBugVC {
    func saveFeedBack() {
        
        var db = Firestore.firestore()
        let data: [String: Any] = [
            "attachURL"        : downloadedURL ,
            "reason": self.txtViewBio.text!
        ]
        if self.tag == 0 {
            db.collection("FeedBack_Bug").addDocument(data: data) { [weak self] error in
                guard let strongSelf = self else { return }
                if let error = error {
                    self?.stopAnimating()
                    self?.showToast(message: "Error adding document: \(error.localizedDescription)", seconds: 2, clr: .red)
                } else {
                    self?.showToast(message: "Document added successfully.", seconds: 2, clr: .gray)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.popRoot()
                    }
                }
            }
        }
        //Suggestion
        else{
            db.collection("FeedBack_Suggestion").addDocument(data: data) { [weak self] error in
                guard let strongSelf = self else { return }
                if let error = error {
                    self?.stopAnimating()
                    self?.showToast(message: "Error adding document: \(error.localizedDescription)", seconds: 2, clr: .red)
                } else {
                    self?.showToast(message: "Document added successfully.", seconds: 2, clr: .gray)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.popRoot()
                    }
                }
            }
        }
    }
    func feedBackCall(_ img: UIImage, userID: String) {
        self.startAnimating()
        if reachability.isReachable {
            let uniqueID = UUID().uuidString
            let storageRef = Storage.storage().reference().child("FeedBack/\(uniqueID).png") // Store in "covers" directory
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
                    self.downloadedURL = downloadURL.absoluteString
                }
            }
        } else {
            self.showToast(message: "Internet connection is off.", seconds: 2, clr: .red)
        }
    }
}
//MARK: - Get Image {}
extension ResonOfBugVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickImg() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        imgAttach.image = image
        feedBackCall(imgAttach.image!, userID: UserDefault.token)
        
    }
}
