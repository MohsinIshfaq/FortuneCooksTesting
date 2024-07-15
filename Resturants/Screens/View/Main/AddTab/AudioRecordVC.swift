//
//  AudioRecordVC.swift
//  Resturants
//
//  Created by Coder Crew on 17/03/2024.
//

import UIKit
import AVFoundation
import AVKit

class AudioRecordVC: AudioViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var btnRecord         : UIButton!
    @IBOutlet weak var progressRecording : UIProgressView!
    @IBOutlet weak var btnPlay           : UIButton!
    @IBOutlet weak var btnDismiss        : UIButton!
    @IBOutlet weak var btnNext           : UIButton!
    
    //MARK: - Variables and Properties
    var outputURL              : URL?        = nil
    var player                 : AVPlayer!   = nil
    var avpController                        = AVPlayerViewController()
    private var selectedRecord : Bool        = false
    private var timer          : Timer?      = nil
    var totalTime              : Float       = 0.0 // Total time in seconds
    private var elapsedTime    : Float       = 0.0 // Elapsed time
    private var progress_value               = 0.1
    private var mergedVideoURL : URL?        = nil
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapNext(_ sender: UIButton) {
        UserManager.shared.finalURL  = mergedVideoURL
        popRoot()
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton) {
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "ConfirmationActionVC") as! ConfirmationActionVC
        vc.delegate               = self
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func ontapPlay(_ sender: UIButton){
       
        mergeAudioWithVideo(videoURL: outputURL!, audioURL: getRecordedAudioFile()!) { mergedURL in
            if let mergedURL = mergedURL {
                // Merged video with audio successfully, use the mergedURL as needed
                print("Merged video with audio URL: \(mergedURL)")
                DispatchQueue.main.async {
                    let player = AVPlayer(url: mergedURL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    
                    self.present(playerViewController, animated: true) {
                        player.play()
                    }
                }
            } else {
                // Failed to merge video with audio
                print("Failed to merge video with audio.")
            }
        }
    }
    
    @IBAction func ontapRecord(_ sender: UIButton){
        
        selectedRecord.toggle()
        btnRecord.backgroundColor = selectedRecord == true ? .red : .ColorDarkBlue
        if selectedRecord{
            startProgress()
            if audioRecorder == nil {
                startAudioRecording()
            }
            player.play()
            btnRecord.isHidden = true
        }
        else{
            stopProgress()
            finishAudioRecording(success: true)
        }
    }
}

//MARK: - Setup View{}
extension AudioRecordVC{
    
    func onLoad(){
        self.outputURL        = UserManager.shared.finalURL
        self.showNavBar()
        setupAudioRecording()
        muteVideo()
        removeNavBackbuttonTitle()
        btnDismiss.isHidden   = true
        btnNext.isHidden      = true
    }
    func onAppear(){
        
    }
    
    func playVideo() {
        
        if let url = mergedVideoURL == nil ? outputURL : mergedVideoURL {
             player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(playerLayer)
            if mergedVideoURL != nil{
                player.play()
            }
            view.bringSubviewToFront(btnRecord)
            view.bringSubviewToFront(progressRecording)
            view.bringSubviewToFront(btnPlay)
            view.bringSubviewToFront(btnDismiss)
            view.bringSubviewToFront(btnNext)
        }
    }
    
    func muteVideo() {
        guard let url = self.outputURL else {
            return
        }
        removeAudioFromVideo(url) { url , error in
            DispatchQueue.main.async { // Ensure UI updates are done on the main thread
                if let error = error {
                    self.showToast(message: "\(error)", seconds: 2, clr: .red)
                } else {
                    self.outputURL = url
                    self.playVideo()
                }
            }
        }
    }
    
    func startProgress() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
        elapsedTime                   += 0.1 // Update elapsed time
        let progress                   = elapsedTime / totalTime
        progressRecording.progress     = progress
        self.progress_value           += 0.05
        if elapsedTime >= totalTime {
            timer?.invalidate()
            timer                      = nil
            btnDismiss.isHidden        = false
            selectedRecord             = false
            stopProgress()
            finishAudioRecording(success: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.mergeVideo()
            }
        }
    }
    
    func stopProgress() {
        timer?.invalidate()
        timer = nil
    }
    
    func mergeVideo(){
        mergeAudioWithVideo(videoURL: outputURL!, audioURL: getRecordedAudioFile()!) { mergedURL in
            if let mergedURL = mergedURL {
                // Merged video with audio successfully, use the mergedURL as needed\
                self.mergedVideoURL = mergedURL
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.playVideo()
                    self.btnNext.isHidden = false
                }
            } else {
                // Failed to merge video with audio
                print("Failed to merge video with audio.")
            }
        }
    }
    
    func playRecordedAudio() {
        
        if let recordedAudioURL = getRecordedAudioFile() {
            let player = AVPlayer(url: recordedAudioURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.play()
            }
        } else {
            print("Recorded audio file not found.")
        }
    }
}
//MARK: - Protocol for action on recorded video about rerecording or not {}
extension AudioRecordVC : ConfirmationAutionsDelegate{
    
    func willDelete(_ condition: Bool) {
        if condition{
            self.dismiss(animated: true)
            progressRecording.progress = 0
            btnRecord.backgroundColor  = .ColorDarkBlue
            btnRecord.isHidden         = false
            btnDismiss.isHidden        = true
            elapsedTime                = 0
            progress_value             = 0
            mergedVideoURL             = nil
            audioRecorder              = nil
            btnNext.isHidden           = true
            playVideo()
        }
        else{
            self.dismiss(animated: true)
        }
    }
}

