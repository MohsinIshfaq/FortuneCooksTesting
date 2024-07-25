//
//  UploadingVC.swift
//  Resturants
//
//  Created by Coder Crew on 08/04/2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestoreInternal

class UploadingVC: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var lblProgress : UILabel!
    @IBOutlet weak var ProgressBr  : UIProgressView!
    
    //MARK: - Variables and Properties
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var UploadVideoModel    : [String: Any] = [:]
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBackgroundTask()
        startVideoUpload()
        hideNavBar()
    }
    @IBAction func ontapopUp(_ sender: UIButton){
        UserManager.shared.gothroughUploading = true
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
                        self.UploadVideoModel["videoUrl"] = "\(url!)"
                       // self.uploadDataToFirestore()
                        self.SaveVideosData()
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
    
    func SaveVideosData() {
        var db = Firestore.firestore()
        let tagUsers: [UserTagModel] = self.UploadVideoModel["tagPersons"] as! [UserTagModel]
        let tagUserDictionaries = tagUsers.map { $0.toDictionary() }
        let data: [String: Any] = [
            "uid"              : self.UploadVideoModel["uid"] as! String ,
            "address"          : self.UploadVideoModel["address"] as! String,
            "zipcode"          : self.UploadVideoModel["zipcode"] as! String,
            "city"             : self.UploadVideoModel["city"] as! String,
            "title"            : self.UploadVideoModel["title"] as! String,
            "tagPersons"       : tagUserDictionaries,
            "description"      : self.UploadVideoModel["description"] as! String,
            "categories"       : self.UploadVideoModel["categories"] as! [String],
            "hashtages"        : self.UploadVideoModel["hashtages"] as! [String],
            "language"         : self.UploadVideoModel["language"] as! String,
            "videoUrl"         : self.UploadVideoModel["videoUrl"] as! String,
            "thumbnailUrl"     : self.UploadVideoModel["thumbnailUrl"] as! String,
            "likes"            : self.UploadVideoModel["Likes"] as! Bool,
            "comments"         : self.UploadVideoModel["comments"] as! Bool,
            "views"            : self.UploadVideoModel["views"] as! Bool,
            "paidCollab"       : self.UploadVideoModel["paidCollab"] as! Bool,
            "introVideos"      : self.UploadVideoModel["introVideos"] as! Bool
        ]
        print(data)
        db.collection("Videos&Swifts").addDocument(data: data) { [weak self] error in
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

