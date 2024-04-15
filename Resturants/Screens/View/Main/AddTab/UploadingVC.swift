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
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBackgroundTask()
        startVideoUpload()
        hideNavBar()
    }
    @IBAction func ontapopUp(_ sender: UIButton){
        popRoot()
    }
    @IBAction func ontapCancelUplaod(_ sender: UIButton) {
        endBackgroundTask()
    }
    
    func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        })
    }
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
        self.backgroundTask = .invalid
    }
        
    
    func startVideoUpload() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Replace 'pathToVideo' with the actual URL of the video you want to upload
        guard let pathToVideo = UserManager.shared.finalURL else {
            showToast(message: "Error: Video file not found.", seconds: 2, clr: .red)
            print("Error: Video file not found.")
            return
        }
        // Convert the video file to Data
        guard let videoData = try? Data(contentsOf: pathToVideo) else {
            showToast(message: "Error: Failed to convert video file to Data.", seconds: 2, clr: .red)
            print("Error: Failed to convert video file to Data.")
            return
        }
        let videoRef = storageRef.child("videos/\(UUID().uuidString).mp4")
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        
        let uploadTask = videoRef.putData(videoData, metadata: metadata) { metadata, error in
            if let error = error {
                self.showToast(message: "Error uploading video: \(error.localizedDescription)", seconds: 2, clr: .red)
                print("Error uploading video: \(error.localizedDescription)")
            } else {
                videoRef.downloadURL { url, error in
                    if error == nil {
                        //WE WILL GOT VIDEO FROM THIS URL
                    }
                    else{
                        self.showToast(message: error?.localizedDescription ?? "", seconds: 2, clr: .red)
                    }
                }
                self.handleUploadCompletion()
            }
            self.endBackgroundTask()
        }
        
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let progressPercentage = Int(progress.fractionCompleted * 100)
            print("Upload progress: \(progressPercentage)%")
            DispatchQueue.main.async {
                self.lblProgress.text = "Upload Progress: \(progressPercentage)%"
                self.ProgressBr.progress = Float(progress.fractionCompleted)
            }
        }
    }
        
    private func handleUploadCompletion() {
        DispatchQueue.main.async {
            self.showToast(message: "Successfully Uploaded", seconds: 2, clr: .gray)
        }
    }

}
