//
//  UploadingVC.swift
//  Resturants
//
//  Created by Coder Crew on 08/04/2024.
//

import UIKit
import FirebaseStorage

class UploadingVC: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var lblProgress : UILabel!
    @IBOutlet weak var ProgressBr  : UIProgressView!
    
    //MARK: - Variables and Properties
    var uploadTask: StorageUploadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startVideoUpload()
        hideNavBar()
    }
    @IBAction func ontapopUp(_ sender: UIButton){
        popRoot()
    }
    @IBAction func ontapCancelUplaod(_ sender: UIButton) {
        uploadTask?.cancel()
    }
    
    func startVideoUpload() {
       // self.startAnimating()
        // Your video upload logic goes here
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Replace 'pathToVideo' with the actual URL of the video you want to upload
        guard let pathToVideo = UserManager.shared.finalURL else {
           // self.stopAnimating()
            self.showToast(message: "Error: Video file not found.", seconds: 2, clr: .red)
            print("Error: Video file not found.")
            return
        }
        // Convert the video file to Data
        guard let videoData = try? Data(contentsOf: pathToVideo) else {
          //  self.stopAnimating()
            self.showToast(message: "Error: Failed to convert video file to Data.", seconds: 2, clr: .red)
            print("Error: Failed to convert video file to Data.")
            return
        }
        let videoRef = storageRef.child("videos/\(UUID().uuidString).mp4")
        uploadTask = videoRef.putData(videoData, metadata: nil) { metadata, error in
            if error == nil {
              //  self.stopAnimating()
                self.handleUploadCompletion()
            } else {
              //  self.stopAnimating()
                self.showToast(message: "Error uploading video: \(error!.localizedDescription)", seconds: 2, clr: .red)
                print("Error uploading video: \(error!.localizedDescription)")
            }
        }
        
        uploadTask?.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let progressPercentage = Int(progress.fractionCompleted * 100)
            print("Upload progress: \(progressPercentage)%")
            DispatchQueue.main.async {
                self.lblProgress.text      = "Upload Progress: \(progressPercentage)%"
                self.ProgressBr.progress   = Float(progress.fractionCompleted)
            }
            if progressPercentage == 100 {
              //  self.stopAnimating()
            }
        }
    }
    
    private func handleUploadCompletion() {
        // Stop animation and show toast message
        DispatchQueue.main.async {
          //  self.stopAnimating()
            self.showToast(message: "Successfully Uploaded", seconds: 2, clr: .gray)
        }
    }

}
