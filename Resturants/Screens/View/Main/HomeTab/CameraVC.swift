//
//  CameraVC.swift
//  Resturants
//
//  Created by Coder Crew on 07/03/2024.
//

import UIKit
import Photos
import AVFoundation
import AVKit
import MobileCoreServices

class CameraVC: FilterCamViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var btnRecord         : UIButton!
    @IBOutlet weak var progressRecording : UIProgressView!
    @IBOutlet weak var CollectFilter     :  UICollectionView!
    @IBOutlet weak var lblProgress       : UILabel!
    @IBOutlet weak var stackEditOpt      : UIStackView!
    
    //MARK: - variables and Properties
    private var selected                 : Bool = false
    private var selectedRecord           : Bool = false
    private var timer                    : Timer?
    private let totalTime                : Float = 30.0 // Total time in seconds
    private var elapsedTime              : Float = 0.0 // Elapsed time
    private var progress_value           = 0.1
    private var outputURL: URL?          = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    @objc func ontapCameraRoll() {
        
        toggleCamera()
    }
    
    @objc func ontapFlash() {
        
        if torchLevel == 1{
            torchLevel = 0
        }
        else{
            torchLevel = 1
        }
        selected.toggle()
        NavigationRightBtns()
    }
    
    @IBAction func ontapVoiceOver(_ sender: UIButton){
        
    }
    
    @IBAction func ontapMute(_ sender: UIButton){
        guard let url = self.outputURL else {
            return
        }
        removeAudioFromVideo(at: url) { url in
            if let url = url {
                self.outputURL = url
                DispatchQueue.global(qos: .background).async {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                    }) { success, error in
                        if success {
                            // Video saved successfully
                            self.showToast(message: "Video saved successfully", seconds: 1, clr: .gray)
                            print("Video saved successfully")
                        } else {
                            // Failed to save video
                            self.showToast(message: "\(error?.localizedDescription ?? "Unknown error")", seconds: 1, clr: .gray)
                            print("Failed to save video: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func ontapRecord(_ sender: UIButton){
        selectedRecord.toggle()
        btnRecord.backgroundColor = selectedRecord == true ? .red : .ColorDarkBlue
        if selectedRecord{
            startProgress()
            self.startRecording()
        }
        else{
            progressRecording.progress = 0
            self.lblProgress.text      = "0"
            stopProgress()
            self.stopRecording()
            
        }
    }
    
    @IBAction func ontapPickFromGallery(_ sender: UIButton){
        pickVideo()
    }
    
}

//MARK: - Extension of setup Data{}
extension CameraVC {
    func onLoad() {
        removeNavBackbuttonTitle()
        NavigationRightBtns()
        setupFilterCollection()
        cameraDelegate = self
        self.navigationItem.title = "Swift"
        self.stackEditOpt.isHidden = true
    }
    
    func onAppear() {
    }
    
    func setupFilterCollection(){
        
        CollectFilter.register(FrameFilterCell.nib, forCellWithReuseIdentifier: FrameFilterCell.identifier)
        //CollectFilter.collectionViewLayout = UICollectionViewFlowLayout()
        CollectFilter.delegate   = self
        CollectFilter.dataSource = self
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
    
    func stopProgress() {
        timer?.invalidate()
        timer = nil
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
}

//MARK: - Extension of Filter {}
extension CameraVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.FakefilterNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FrameFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FrameFilterCell.identifier, for: indexPath) as! FrameFilterCell
        if indexPath.row == 0 {
            cell.lblFilter.text = "Normal"
        }
        else{
            cell.lblFilter.text = "Filter \(indexPath.row)"
        }
        cell.lblFilter.textColor = UserManager.shared.FakefilterNameList[indexPath.row][1] as! Int == 1 ? .white : .lightGray
        cell.btn.addTarget(self, action: #selector(ontapFilter(_ :)), for: .touchUpInside)
        cell.btn.tag = indexPath.row
        return cell
    }
    
    @objc func ontapFilter(_ sender: UIButton) {
        // Remove all previous filters before applying the new one
        filters.removeAll()

        for (index, _) in UserManager.shared.FakefilterNameList.enumerated() {
            if index == sender.tag {
                UserManager.shared.FakefilterNameList[index][1] = 1
                if let name = UserManager.shared.FakefilterNameList[index][0] as? String {
                    if name == "No Filter" {
                        filters.removeAll()
                    }
                    else{
                        let filter = CIFilter(name: name)!
                        filters.append(filter)
                    }
                }
            } else {
                UserManager.shared.FakefilterNameList[index][1] = 0
            }
        }
        CollectFilter.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 40)
    }
    
}

//MARK: - Extension of setup Data{}
extension CameraVC: FilterCamViewControllerDelegate{
    
    func filterCamDidStartRecording(_ filterCam: FilterCamViewController) {
        
    }

    func filterCamDidFinishRecording(_ filterCame: FilterCamViewController) {
        
    }

    func filterCam(_ filterCam: FilterCamViewController, didFailToRecord error: Error) {
        self.showAlertWith(title: "Error", message: error.localizedDescription)
    }

    func filterCam(_ filterCam: FilterCamViewController, didFinishWriting outputURL: URL) {
        self.outputURL = outputURL
        DispatchQueue.main.sync {
            self.stackEditOpt.isHidden = false
        }
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
//            }) { success, error in
//                if success {
//                    // Video saved successfully
//                    self.showToast(message: "Video saved successfully", seconds: 1, clr: .gray)
//                    print("Video saved successfully")
//                } else {
//                    // Failed to save video
//                    self.showToast(message: "\(error?.localizedDescription ?? "Unknown error")", seconds: 1, clr: .gray)
//                    print("Failed to save video: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        }
    }

    func filterCam(_ filterCam: FilterCamViewController, didFocusAtPoint tapPoint: CGPoint) {
        
    }
}

//MARK: - Video Picker {}
extension CameraVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickVideo() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String] // This ensures only videos are shown
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let videoURL = info[.mediaURL] as? URL else {
            print("Error getting video URL")
            return
        }
        self.outputURL = videoURL
        // Use the videoURL as needed
    }
}


//MARK: - Mute Audio {}
extension CameraVC {

    func removeAudioFromVideo(at videoURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: videoURL)
        
        // Create a mutable composition
        let composition = AVMutableComposition()
        
        // Add video track from the original asset
        guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
              let assetVideoTrack = asset.tracks(withMediaType: .video).first else {
            completion(nil)
            return
        }
        
        // Insert video track from the original asset to the mutable composition
        do {
            try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: assetVideoTrack, at: .zero)
        } catch {
            print("Error inserting video track: \(error)")
            completion(nil)
            return
        }
        
        // Create an instruction to disable the audio track
        let audioInstruction = AVMutableVideoCompositionInstruction()
        audioInstruction.timeRange = CMTimeRange(start: .zero, duration: asset.duration)
        
        let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        audioTrack?.removeTimeRange(CMTimeRange(start: .zero, duration: asset.duration))
        
        // Export the composition
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil)
            return
        }
        
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("muted_video.mp4")
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(outputURL)
            case .failed:
                print("Export failed: \(exportSession.error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            case .cancelled:
                print("Export cancelled")
                completion(nil)
            default:
                print("Export status: \(exportSession.status.rawValue)")
                completion(nil)
            }
        }
    }
}
