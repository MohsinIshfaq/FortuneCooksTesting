//
//  UploadSwift2VC.swift
//  Resturants
//
//  Created by Coder Crew on 06/04/2024.
//

import UIKit
import FirebaseStorage

class UploadSwift2VC: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var lblProgress   : UILabel!
    @IBOutlet weak var switchLike    : UISwitch!
    @IBOutlet weak var switchComment : UISwitch!
    @IBOutlet weak var switchViews   : UISwitch!
    @IBOutlet weak var switchPaid    : UISwitch!
    @IBOutlet weak var switchIntro   : UISwitch!
    @IBOutlet weak var vwPublic      : UIView!
    @IBOutlet weak var lblPublic     : UILabel!
    @IBOutlet weak var vwFollowers   : UIView!
    @IBOutlet weak var lblFollowers  : UILabel!
    @IBOutlet weak var vwOnlyMe      : UIView!
    @IBOutlet weak var lblOnlyMe     : UILabel!

    @IBOutlet weak var imgFavourites : UIImageView!
    @IBOutlet weak var imgPasta      : UIImageView!
    @IBOutlet weak var imgChicken    : UIImageView!
    
    //MARK: - Variables and Properties
    var uploadTask: StorageUploadTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func ontapVideoType(_ sender: UIButton){
        if sender.tag == 0{
            vwPublic.backgroundColor    = .white
            lblPublic.textColor         = .black
            vwFollowers.backgroundColor = .clear
            lblFollowers.textColor      = .white
            vwOnlyMe.backgroundColor    = .clear
            lblOnlyMe.textColor         = .white
        }
        else if sender.tag == 1{
            vwPublic.backgroundColor    = .clear
            lblPublic.textColor         = .white
            vwFollowers.backgroundColor = .white
            lblFollowers.textColor      = .black
            vwOnlyMe.backgroundColor    = .clear
            lblOnlyMe.textColor         = .white
        }
        else{
            vwPublic.backgroundColor    = .clear
            lblPublic.textColor         = .white
            vwFollowers.backgroundColor = .clear
            lblFollowers.textColor      = .white
            vwOnlyMe.backgroundColor    = .white
            lblOnlyMe.textColor         = .black
        }
    }
    
    @IBAction func ontapCollections(_ sender: UIButton){
        if sender.tag == 0{
            imgFavourites.image = UIImage(systemName: "bookmark.fill")
            imgPasta.image      = UIImage(systemName: "bookmark")
            imgChicken.image    = UIImage(systemName: "bookmark")
        }
        else if sender.tag == 1{
            imgFavourites.image = UIImage(systemName: "bookmark")
            imgPasta.image      = UIImage(systemName: "bookmark.fill")
            imgChicken.image    = UIImage(systemName: "bookmark")
        }
        else{
            imgFavourites.image = UIImage(systemName: "bookmark")
            imgPasta.image      = UIImage(systemName: "bookmark")
            imgChicken.image    = UIImage(systemName: "bookmark.fill")
            
        }
    }
    
    @IBAction func ontapPublishVideo(_ sender: UIButton){
        
        // Create a progress view
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.setProgress(0, animated: false)
        
        // Embed the progress view into a bar button item
        let progressItem = UIBarButtonItem(customView: progressView)
        navigationItem.rightBarButtonItem = progressItem
        
        // Start uploading the video
        startVideoUpload()
    }
    
    func startVideoUpload() {
        self.startAnimating()
        // Your video upload logic goes here
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Replace 'pathToVideo' with the actual URL of the video you want to upload
        guard let pathToVideo = UserManager.shared.finalURL else {
            self.stopAnimating()
            print("Error: Video file not found.")
            return
        }
        // Convert the video file to Data
        guard let videoData = try? Data(contentsOf: pathToVideo) else {
            self.stopAnimating()
            print("Error: Failed to convert video file to Data.")
            return
        }
        
        // Create a reference for the video in Firebase Storage
        let videoRef = storageRef.child("videos/\(UUID().uuidString).mp4")
        
        // Upload the video data to Firebase Storage
        uploadTask = videoRef.putData(videoData, metadata: nil) { metadata, error in
            if error == nil {
                // Upload successful
                self.handleUploadCompletion()
            } else {
                // Handle error
                print("Error uploading video: \(error!.localizedDescription)")
            }
        }
        
        // Observe the upload progress
        uploadTask?.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            // Update the progress view if you have one
            let progressPercentage = Int(progress.fractionCompleted * 100)
            print("Upload progress: \(progressPercentage)%")
            DispatchQueue.main.async {
                // Assuming you have a progress label named progressLabel
               // self.lblProgress.isHidden  = false
              //  self.lblProgress.text      = "Upload Progress: \(progressPercentage)%"
               // self.startAnimating(message: "Upload Progress: \(progressPercentage)%")
            }
            if progressPercentage == 100 {
                self.stopAnimating() // Stop animation when upload is complete
            }
        }
    }
    
    private func handleUploadCompletion() {
        // Stop animation and show toast message
        DispatchQueue.main.async {
            self.stopAnimating()
            self.showToast(message: "Successfully Uploaded", seconds: 2, clr: .gray)
        }
    }

}
