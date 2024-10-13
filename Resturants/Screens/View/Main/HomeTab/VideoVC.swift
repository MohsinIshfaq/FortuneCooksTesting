//
//  VideoVC.swift
//  Resturants
//
//  Created by Mohsin on 11/10/2024.
//

import UIKit
import AVKit
import AVFoundation

class VideoVC: UIViewController {

    //MARK: - @IBOutlets -
    
    @IBOutlet weak var imgPlayAndPause: UIImageView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var viewForVideo: UIView!
    @IBOutlet var arrayForVideoIndicator: [UIView]!
    
    //MARK: - Variables -
    
    var videoURL: URL?
    var startTime: Double = 0.0
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying: Bool = true
    var isShowVideoIndicator: Bool = true
    var handler: (((time: Double, isPlaying: Bool)) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
    }
    
    private func setupVideoPlayer() {
        guard let videoURL = videoURL else {
            print("Invalid video URL")
            return
        }
        
        player = AVPlayer(url: videoURL)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        viewForVideo.layer.addSublayer(playerLayer)
        
        playerLayer.frame = viewForVideo.bounds
        addTimeObserver()
        let seekTime = CMTime(seconds: startTime, preferredTimescale: 1000)
        player.seek(to: seekTime) { [weak self] _ in
            self?.onClickPlayPause()
        }
    }
    
    func playAgain() {
        let currentTime = trim(lblCurrentTime.text)
        let totalTime = trim(lblTotalTime.text)
        
        let isFinish = currentTime == totalTime
        guard isFinish else { return }
        
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            guard let self = self, let currentItem = self.player.currentItem else { return }
            
            let currentTime = currentItem.currentTime().seconds
            let duration = currentItem.duration.seconds
            
            if currentTime.isFinite && currentTime >= 0, duration.isFinite && duration > 0 {
                self.timeSlider.maximumValue = Float(duration)
                self.timeSlider.value = Float(currentTime)
                self.lblCurrentTime.text = "\(formatTime(from: currentItem.currentTime()))"
                self.lblTotalTime.text = formatTime(from: currentItem.duration)
            } else {
                self.lblCurrentTime.text = "--:--"
                self.lblTotalTime.text = "--:--"
            }
        }
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        imgPlayAndPause.image = UIImage(named: "imgPlay")
        isPlaying = false
        timeSlider.value = timeSlider.maximumValue
        lblCurrentTime.text = formatTime(from: player.currentItem?.duration ?? CMTime.zero)
//        player.seek(to: .zero)
//        player.play()
    }
    
    private func seekToTime(newTime: Double) {
        let time = CMTime(seconds: newTime, preferredTimescale: 1000)
        player.seek(to: time)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = viewForVideo.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - @@IBAction -
    
    @IBAction func onClickVideoBack() {
        isShowVideoIndicator = !isShowVideoIndicator
        arrayForVideoIndicator.forEach({ $0.isHidden = !isShowVideoIndicator })
        timeSlider.isHidden = !isShowVideoIndicator
    }
    
    @IBAction func onClickDismiss() {
        let startTime = self.player.currentItem?.currentTime().seconds ?? 0
        let videoParam = (startTime, !isPlaying)
        handler?(videoParam)
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickPlayPause() {
        if isPlaying {
            player.pause()
            imgPlayAndPause.image = UIImage(named: "imgPlay")
        } else {
            playAgain()
            player.play()
            imgPlayAndPause.image = UIImage(named: "imgPause")
        }
        isPlaying.toggle()
    }
    
    @IBAction func onEditingChangeSlider(_ sender: UISlider) {
        let newTime = CMTimeMake(value: Int64(sender.value * 1000), timescale: 1000)
        lblCurrentTime.text = formatTime(from: newTime)
        player.seek(to: newTime)
    }
    
    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
        let newTime = Double(sender.value)
        seekToTime(newTime: newTime)
    }
    
    @IBAction func onClickExitFullScreen() {
        
    }

}
