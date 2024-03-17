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
    
    //MARK: - Variables and Properties
    var outputURL              : URL?         = nil
    var player                 : AVPlayer!    = nil
    var avpController                        = AVPlayerViewController()
    private var selectedRecord : Bool        = false
    private var timer          : Timer?      = nil
    var totalTime              : Float       = 0.0 // Total time in seconds
    private var elapsedTime    : Float       = 0.0 // Elapsed time
    private var progress_value               = 0.1
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
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
            playVideo()
        }
        else{
            progressRecording.progress = 0
            elapsedTime                = 0
            progress_value             = 0
            stopProgress()
            finishAudioRecording(success: true)
        }
    }
}

//MARK: - Setup View{}
extension AudioRecordVC{
    
    func onLoad(){
        self.showNavBar()
        setupAudioRecording()
        muteVideo()
        removeNavBackbuttonTitle()
    }
    func onAppear(){
        
    }
    
    func playVideo() {
        
        if let url = outputURL {
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(playerLayer)
            player.play()
            view.bringSubviewToFront(btnRecord)
            view.bringSubviewToFront(progressRecording)
            view.bringSubviewToFront(btnPlay)
        }
    }
    
    func muteVideo() {
        
        guard let url = self.outputURL else {
            return
        }
        removeAudioFromVideo(url) { url , error in
            if error != nil {
                self.showToast(message: "\(error)", seconds: 2, clr: .red)
            }
            else{
                self.outputURL = url
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
            progressRecording.progress = 0
            elapsedTime                = 0
            progress_value             = 0
            stopProgress()
            btnRecord.backgroundColor  = .ColorDarkBlue
            finishAudioRecording(success: true)
        }
    }
    
    func stopProgress() {
        timer?.invalidate()
        timer = nil
    }
    
    func playRecordedAudio() {
        if let recordedAudioURL = getRecordedAudioFile() {
            // Create an AVPlayer instance
            let player = AVPlayer(url: recordedAudioURL)
            
            // Create an AVPlayerViewController instance
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            // Present the player view controller
            present(playerViewController, animated: true) {
                player.play()
            }
        } else {
            print("Recorded audio file not found.")
        }
    }
}
