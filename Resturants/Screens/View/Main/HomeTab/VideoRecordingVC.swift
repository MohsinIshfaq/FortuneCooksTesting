//
//  VideoRecordingVC.swift
//  Resturants
//
//  Created by shah on 25/02/2024.
//

import UIKit
import Photos
import AVFoundation
import AVKit
import MobileCoreServices

class VideoRecordingVC: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var btnRecord         : UIButton!
    @IBOutlet weak var progressRecording : UIProgressView!
    @IBOutlet weak var vwMain            : UIView!
    @IBOutlet weak var imgPreview        : UIImageView!
    
    //MARK: - variables and Properties
    private var selected       : Bool = false
    private var selectedRecord : Bool = false
    var timer: Timer?
    let totalTime: Float = 30.0 // Total time in seconds
    var elapsedTime: Float = 0.0 // Elapsed time
    var captureSession: AVCaptureSession!
    var videoDevice   : AVCaptureDevice?
    var cameraSession : AVCaptureDeviceInput!
    var previewLayer  : AVCaptureVideoPreviewLayer!
    var videoComtroller = UIImagePickerController()
    var cameraConfig  : CameraConfiguration!
    var selectedURL   : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapRecord(_ sender: UIButton){
        selectedRecord.toggle()
        btnRecord.backgroundColor = selectedRecord == true ? .red : .link
        elapsedTime = 0.0 // Elapsed time
        self.cameraConfig.outputType = .video
        
        if selectedRecord{
            startProgress()
            self.cameraConfig.recordVideo { url, error in
                guard let url = url else {
                    self.showAlertWith(title: "Error!", message: "\(url)")
                    return
                }
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(self.video(_:didFinishSavingError: contextInfo:)), nil)
            }
        }
        else{
            stopProgress()
            elapsedTime = 0.0 // Elapsed time
            self.cameraConfig.stopRecording {[weak self] error in
                self?.showAlertWith(title: "Error!", message: "\(error?.localizedDescription ?? "")")
            }
        }
    }
    
    @objc func video(_ video: String , didFinishSavingError error: NSError? , contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.showAlertWith(title: "Error!", message: "Could Not Save \(error.localizedDescription)")
        }
        else{
            self.selectedURL = URL(string: "file://" + video)
        }
    }
    
    @objc func ontapCameraRoll() {
        do {
            try cameraConfig.switchCameras()
        }
        catch{
            self.showAlertWith(title: "Error!", message: "\(error.localizedDescription)")
        }
    }
    
    @objc func ontapFlash() {
        selected.toggle()
        NavigationRightBtns()
        cameraConfig.toggleFlashlight()
    }
}

//MARK: - Extension of setup Data{}
extension VideoRecordingVC {
    func onLoad() {
        removeNavBackbuttonTitle()
        NavigationRightBtns()
        setupVideo()
    }
    func onAppear() {
        
    }
    
    func setupVideo() {
        
        cameraConfig.setup { error in
            if error != nil{
                self.showAlertWith(title: "Error!", message: "\(error!.localizedDescription)")
            }
            try? self.cameraConfig.displayPreview(self.vwMain)
        }
    }
    func NavigationRightBtns() {
        
        let imgCamera = UIImage(systemName: "arrow.triangle.2.circlepath")?.withRenderingMode(.automatic)
        let btnCamera = UIBarButtonItem(image: imgCamera, style: .plain, target: self, action: #selector(ontapCameraRoll))
        btnCamera.tintColor = .white
        let imgFlash = UIImage(systemName: "bolt.fill")?.withRenderingMode(.automatic)
        let btnFlash = UIBarButtonItem(image: imgFlash, style: .plain, target: self, action: #selector(ontapFlash))
        btnFlash.tintColor = selected == true ? .yellow : .white
        navigationItem.rightBarButtonItems = [btnCamera , btnFlash]
    }
    
    func startProgress() {
           timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
       }
       
       @objc func updateProgress() {
           elapsedTime += 0.1 // Update elapsed time
           let progress = elapsedTime / totalTime
           progressRecording.progress = progress
           
           if elapsedTime >= totalTime {
               timer?.invalidate()
               timer = nil
           }
       }
    func stopProgress() {
            timer?.invalidate()
            timer = nil
        }
}

//MARK: - Extension for Camera recording of both sides{}
extension VideoRecordingVC {
    
}
