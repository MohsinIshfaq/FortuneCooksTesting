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


protocol UploadSwiftDelegate {
    func comeBackFromUplaod()
}
class CameraVC: FilterCamViewController , UploadSwiftDelegate{
    
    func comeBackFromUplaod() {
        if let url =  UserManager.shared.finalURL {
            self.getVideoDuration(from: url) { endtime in
                if endtime != nil {
                    self.timer1?.invalidate()
                    self.timer1          = nil
                    self.playVideo(url: url)
                    self.totalTime       = Float(endtime!)
                    self.elapsedTime     = 0
                    self.progress_value  = 0
                    self.navigatePressed = false
                    self.startProgress4TrailVideo()
                }
            }
        }
    }
    

    //MARK: - IBOUtlets
    @IBOutlet weak var btnRecord         : UIButton!
    @IBOutlet weak var progressRecording : UIProgressView!
    @IBOutlet weak var CollectFilter     :  UICollectionView!
    @IBOutlet weak var lblProgress       : UILabel!
    @IBOutlet weak var stackEditOpt      : UIStackView!
    @IBOutlet weak var btnFlash          : UIButton!
    @IBOutlet weak var stackVideoPicker  : UIStackView!
    @IBOutlet weak var btnRemove         : UIButton!
    @IBOutlet weak var btnUpload         : UIButton!
    
    //MARK: - variables and Properties
    var player                           : AVPlayer!   = nil
    var playerLayer                      : AVPlayerLayer? = nil
    private var selected                 : Bool = false
    private var selectedRecord           : Bool = false
    private var timer                    : Timer?
    private var timer1                   : Timer?
    private var totalTime                : Float = 180.0 // Total time in seconds
    private var elapsedTime              : Float = 0.0 // Elapsed time
    private var progress_value           = 0.1
    private var outputURL: URL?          = nil
    private var mutableVideoURL          = NSURL() //final video url
    private var seesionGoing             = false
    private var navigatePressed          = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefault.isAuthenticated {
            let vc  = Constants.authStoryBoard.instantiateViewController(withIdentifier: "LoginNC") as? LoginNC
            vc?.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc!, animated: true)
        }
        else{
            onLoad()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserDefault.isAuthenticated {
            let vc  = Constants.authStoryBoard.instantiateViewController(withIdentifier: "LoginNC") as? LoginNC
            vc?.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc!, animated: true)
        }
        else{
            onAppear()
        }
    }
    
    @IBAction func ontapUpload(_ sender: UIButton){
        self.removeVideo()
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "UplaodSwiftVC") as? UplaodSwiftVC
        vc?.delegate      = self
        vc?.isVideoPicked = false
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func ontapBack(_ sender: UIButton){
        if !self.stackEditOpt.isHidden {
            showTwoWayAlert(title: "Confirmation!", message: "Upon navigating back, the video will be permanently deleted.", on: self) { success in
                if success{
                    self.dismiss(animated: true)
                }
                
            }
        }
        else{
            if !seesionGoing {
                self.dismiss(animated: true)
            }else{
                self.showToast(message: "Action not allowed: Recording in progress.", seconds: 2, clr: .red)
            }
        }
    }
    
    @IBAction func ontapAddCap(_ sender: UIButton){
        self.removeVideo()
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "AddCaptionVC") as! AddCaptionVC
       // var url = UserManager.shared.finalURL == nil ? self.outputURL : UserManager.shared.finalURL
        vc.outputURL              = outputURL
        vc.totalTime              = totalTime
        vc.delegate               = self
        vc.delegate2              = self
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapCameraRoll(_ sender: UIButton) {
        toggleCamera()
    }
    
    @IBAction func ontapFlash(_ sender: UIButton) {
        if torchLevel == 1{
            torchLevel = 0
        }
        else{
            torchLevel = 1
        }
        selected.toggle()
        btnFlash.tintColor = selected == true ? .yellow : .white
    }
    
    @IBAction func ontapVoiceOver(_ sender: UIButton){
        self.removeVideo()
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "AudioRecordVC") as! AudioRecordVC
        vc.outputURL              = outputURL
        vc.totalTime              = totalTime
        vc.delegate               = self
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapRemove(_ sender: UIButton) {
        
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "ConfirmationActionVC") as! ConfirmationActionVC
        vc.delegate               = self
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func ontapMute(_ sender: UIButton){
        self.startAnimating()
        self.timer?.invalidate()
        self.timer          = nil
        self.timer1?.invalidate()
        self.timer1          = nil
        self.elapsedTime    = totalTime
        removeVideo()
//        guard let url = self.outputURL else {
//            return
//        }
        var url = UserManager.shared.finalURL == nil ? self.outputURL : UserManager.shared.finalURL
        guard let url = url else {
            return
        }
        removeAudioFromVideo(url) { url , error in
            if error != nil {
                self.stopAnimating()
                self.showToast(message: "\(error)", seconds: 2, clr: .red)
            }
            else {
                self.stopAnimating()
               // self.removeVideo()
                DispatchQueue.main.async {
                    UserManager.shared.finalURL = url
                    self.getVideoDuration(from: url!) { endtime in
                        if endtime != nil {
                            self.playVideo(url: url!)
                            self.totalTime      = Float(endtime!)
                            self.elapsedTime    = 0
                            self.progress_value = 0
                            self.startProgress4TrailVideo()
                        }
                    }
                    self.showToast(message: "Video got muted successfully.", seconds: 2, clr: .gray)
                }
            }
        }
    }
    
    @IBAction func ontapRecord(_ sender: UIButton){
        
        selectedRecord.toggle()
        CollectFilter.isHidden         = true
        stackVideoPicker.isHidden      = true
        if selectedRecord{
            navigatePressed            = false
            btnRecord.backgroundColor  = .red
            elapsedTime                = 0
            seesionGoing               = true
            startProgress()
            self.startRecording()
        }
        else{
            self.startAnimating()
            stopProgress()
            self.stopRecording()
            seesionGoing               = false
            btnRecord.isHidden         = true
        }
    }
    
    @IBAction func ontapPickFromGallery(_ sender: UIButton){
        self.pickVideo()
    }
    
    @objc func updateProgress4TrialVideo() {
        elapsedTime                   += 0.1 // Update elapsed time
        let progress                   = elapsedTime / totalTime
        progressRecording.progress     = progress
        self.progress_value           += 0.1
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        lblProgress.text = String(format: "%02d:%02d", minutes, seconds)
       // lblProgress.text               = "\(Int(self.progress_value))"
        if elapsedTime >= totalTime {
            timer1?.invalidate()
            timer1         = nil
            if !navigatePressed {
                player.seek(to: CMTime.zero)
                player.play()
                self.progress_value   = 0
                self.lblProgress.text = "0"
                self.elapsedTime      = 0
                self.startProgress4TrailVideo()
            }
        }
    }
    
    @objc func updateProgress() {
        elapsedTime                   += 0.1 // Update elapsed time
        let progress                   = elapsedTime / totalTime
        progressRecording.progress     = progress
        self.progress_value           += 0.1
        // Format the elapsed time as mm:ss
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            lblProgress.text = String(format: "%02d:%02d", minutes, seconds)
      //  lblProgress.text               = "\(Int(self.progress_value))"
        if elapsedTime >= totalTime {
            self.startAnimating()
            timer?.invalidate()
            timer                      = nil
            btnRemove.isHidden         = false
            btnRecord.isHidden         = true
            selectedRecord             = false
            stopProgress()
            self.stopRecording()
            seesionGoing               = false
        }
    }
    
    func getVideoDuration(from url: URL, completion: @escaping (Double?) -> Void) {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        completion(durationInSeconds)
    }
}

//MARK: - Extension of setup Data{}
extension CameraVC {
    func onLoad() {
        if  UserDefault.isAuthenticated {
            removeNavBackbuttonTitle()
            setupFilterCollection()
            cameraDelegate             = self
            self.stackEditOpt.isHidden = true
            btnRemove.isHidden         = true
            btnUpload.isHidden         = true
            self.view.layer.opacity    = 0
            toggleCamera()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.view.layer.opacity = 1
            }
        }
       
    }
    
    func onAppear() {
        self.hideNavBar()
      //  self.totalTime = 180
    }
    
    func setupFilterCollection(){
        
        CollectFilter.register(FrameFilterCell.nib, forCellWithReuseIdentifier: FrameFilterCell.identifier)
        //CollectFilter.collectionViewLayout = UICollectionViewFlowLayout()
        CollectFilter.delegate   = self
        CollectFilter.dataSource = self
    }
    
    func stopProgress() {
        timer?.invalidate()
        timer              = nil
        btnRemove.isHidden = false
    }
    
    func startProgress() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    func startProgress4TrailVideo() {
        timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress4TrialVideo), userInfo: nil, repeats: true)
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
        self.stopAnimating()
        DispatchQueue.main.async {
            self.outputURL               = outputURL
            UserManager.shared.finalURL  = outputURL
            self.stackEditOpt.isHidden   = false
            self.btnUpload.isHidden      = false
            if let url = UserManager.shared.finalURL {
                self.getVideoDuration(from: url) { endtime in
                    if endtime != nil {
                        self.playVideo(url: url)
                        self.totalTime      = Float(endtime!)
                        self.elapsedTime    = 0
                        self.progress_value = 0
                        self.startProgress4TrailVideo()
                    }
                }
            }
        }
    }

    func playVideo(url: URL) {
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.view.bounds
        playerLayer?.videoGravity = .resizeAspectFill
       // self.view.layer.addSublayer(playerLayer!)
        if let playerLayer = playerLayer {
            self.view.layer.addSublayer(playerLayer)
        }
        player?.play()
        self.view.bringSubviewToFront(btnRecord)
        self.view.bringSubviewToFront(progressRecording)
        self.view.bringSubviewToFront(btnUpload)
        self.view.bringSubviewToFront(stackEditOpt)
        self.view.bringSubviewToFront(btnRemove)
        self.view.bringSubviewToFront(lblProgress)
    }
    
    func removeVideo() {
        self.startAnimating()
        navigatePressed = true
        player?.pause()
        while playerLayer?.superlayer != nil {
            playerLayer?.removeFromSuperlayer()
        }
        player = nil
        playerLayer = nil
        self.stopAnimating()
    }
    
    func filterCam(_ filterCam: FilterCamViewController, didFocusAtPoint tapPoint: CGPoint) {
    }
}

//MARK: - Mute Audio {}
extension CameraVC {

    func removeAudioFromVideo(_ videoURL: URL, completion: @escaping (URL?, Error?) -> Void) {
        let inputVideoURL: URL = videoURL
        let sourceAsset = AVURLAsset(url: inputVideoURL)
        let sourceVideoTrack: AVAssetTrack? = sourceAsset.tracks(withMediaType: AVMediaType.video)[0]
        let composition : AVMutableComposition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let x: CMTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: sourceAsset.duration)
        _ = try? compositionVideoTrack!.insertTimeRange(x, of: sourceVideoTrack!, at: CMTime.zero)
        mutableVideoURL = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/FinalVideo.mp4")
        let exporter: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputFileType = AVFileType.mp4
        exporter.outputURL = mutableVideoURL as URL
        removeFileAtURLIfExists(url: mutableVideoURL)
        exporter.exportAsynchronously(completionHandler:
                                        {
            switch exporter.status
            {
            case AVAssetExportSession.Status.failed:
                print("failed \(exporter.error)")
                completion(nil , exporter.error)
            case AVAssetExportSession.Status.cancelled:
                print("cancelled \(exporter.error)")
                completion(nil , exporter.error)
            case AVAssetExportSession.Status.unknown:
                print("unknown\(exporter.error)")
                completion(nil , exporter.error)
            case AVAssetExportSession.Status.waiting:
                print("waiting\(exporter.error)")
                completion(nil , exporter.error)
            case AVAssetExportSession.Status.exporting:
                print("exporting\(exporter.error)")
                completion(nil , exporter.error)
            default:
                print("-----Mutable video exportation complete.")
                completion(self.mutableVideoURL as URL , nil)
            }
        })
    }

    func removeFileAtURLIfExists(url: NSURL) {
            if let filePath = url.path {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    do{
                        try fileManager.removeItem(atPath: filePath)
                    } catch let error as NSError {
                        print("Couldn't remove existing destination file: \(error)")
                    }
                }
            }
        }
    
    func saveVideoToLibrary(at videoURL: URL, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }) { success, error in
                if success {
                    // Video saved successfully
                    completion(nil)
                } else {
                    // Failed to save video
                    completion(error ?? NSError(domain: "VideoSaving", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
    
}

//MARK: - Protocol for action on recorded video about rerecording or not {}
extension CameraVC : ConfirmationAutionsDelegate{
    
    func willDelete(_ condition: Bool) {
        if condition{
            self.dismiss(animated: true)
            self.removeVideo()
            progressRecording.progress  = 0
            self.lblProgress.text       = "0"
            progress_value              = 0
            timer1?.invalidate()
            timer1                      = nil
            timer?.invalidate()
            timer                       = nil
            btnRecord.backgroundColor   = .ColorDarkBlue
            btnRecord.isHidden          = false
            stackEditOpt.isHidden       = true
            btnUpload.isHidden          = true
            outputURL                   = nil
            btnRemove.isHidden          = true
            stackVideoPicker.isHidden   = false
            CollectFilter.isHidden      = false
            self.totalTime              = 180
            UserManager.shared.finalURL = nil
        }
        else{
            self.dismiss(animated: true)
        }
    }
}

//Pick Video From Gallery
extension CameraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UserManager.shared.finalURL  = videoURL
            let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "UplaodSwiftVC") as? UplaodSwiftVC
            vc?.isVideoPicked = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}

//MARK: - protocol from audio Recorded {}
extension CameraVC: AudioRecordDelegate {
    func popupfromAudioRecordVC(elapsedTime: Float, totalTime: Float) {
        self.popup()
        self.elapsedTime = totalTime
        self.totalTime   = totalTime
        let minutes = Int(totalTime) / 60
        let seconds = Int(totalTime) % 60
        lblProgress.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
