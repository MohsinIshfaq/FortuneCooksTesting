//
//  VideoRecordingVC.swift
//  Resturants
//
//  Created by shah on 25/02/2024.
//

import UIKit

class VideoRecordingVC: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var btnRecord         : UIButton!
    @IBOutlet weak var progressRecording : UIProgressView!
    
    //MARK: - variables and Properties
    private var selected       : Bool = false
    private var selectedRecord : Bool = false
    var timer: Timer?
    let totalTime: Float = 30.0 // Total time in seconds
    var elapsedTime: Float = 0.0 // Elapsed time
    
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
        if selectedRecord{
            startProgress()
        }
        else{
            stopProgress()
        }
    }
    
    @objc func ontapCameraRoll() {
        
    }
    
    @objc func ontapFlash() {
        selected.toggle()
        NavigationRightBtns()
    }
}

//MARK: - Extension of setup Data{}
extension VideoRecordingVC {
    func onLoad() {
        removeNavBackbuttonTitle()
        NavigationRightBtns()
    }
    func onAppear() {
        
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
