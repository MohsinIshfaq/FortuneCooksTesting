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
    @IBOutlet weak var lblProgress       : UILabel!
    
    //MARK: - variables and Properties
    private var selected       : Bool = false
    private var selectedRecord : Bool = false
    var timer                  : Timer?
    let totalTime              : Float = 30.0 // Total time in seconds
    var elapsedTime            : Float = 0.0 // Elapsed time
    var captureSession         : AVCaptureSession!
    var videoDevice            : AVCaptureDevice?
    var cameraSession          : AVCaptureDeviceInput!
    var previewLayer           : AVCaptureVideoPreviewLayer!
    var videoComtroller        = UIImagePickerController()
    var cameraConfig           : CameraConfiguration!
    var selectedURL            : URL?
    var progress_value         = 0.1
    
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
        btnRecord.backgroundColor = selectedRecord == true ? .red : .ColorDarkBlue
        elapsedTime               = 0.0 // Elapsed time
        self.cameraConfig.outputType = .video
        
        if selectedRecord{
            startProgress()
            self.cameraConfig.recordVideo { url, error in
                guard let url = url else {
                    self.showAlertWith(title: "Error!", message: "\(url)")
                    return
                }
                let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "EditVideoVC") as? EditVideoVC
                    vc?.urlVideo = url
                    self.navigationController?.pushViewController(vc!, animated: true)
//                UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(self.video(_:didFinishSavingError: contextInfo:)), nil)
            }
        }
        else{
            stopProgress()
            progressRecording.progress = 0
            self.cameraConfig.stopRecording {[weak self] error in
                self?.showAlertWith(title: "Error!", message: "\(error?.localizedDescription ?? "")")
            }
        }
    }
    
    @objc func video(_ video: String , didFinishSavingError error: NSError? , contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.showAlertWith(title: "Error!", message: "Could Not Save \(error.localizedDescription)")
        }
        else {
            // Access the URL of the saved video here
            let videoURL = URL(string: "file://" + video)
            let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "EditVideoVC") as? EditVideoVC
            vc?.urlVideo = videoURL
            self.navigationController?.pushViewController(vc!, animated: true)
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
        lblProgress.text           = "\(0)"
    }
    
    func setupVideo() {
        
        self.cameraConfig = CameraConfiguration()
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
           self.progress_value += 0.05
           lblProgress.text           = "\(Int(self.progress_value))"
           if elapsedTime >= totalTime {
               timer?.invalidate()
               timer = nil
               //btnRecord.backgroundColor = .blue
           }
       }
    func stopProgress() {
            timer?.invalidate()
            timer = nil
        }
}


