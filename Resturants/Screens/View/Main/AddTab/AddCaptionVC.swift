//
//  AddCaptionVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/03/2024.
//

import UIKit
import AVFoundation
import AVKit

class AddCaptionVC: AudioViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var collectColors   : UICollectionView!
    @IBOutlet weak var vwForeground    : UIView!
    @IBOutlet weak var vwBackground    : UIView!
    @IBOutlet weak var lblForground    : UILabel!
    @IBOutlet weak var lblBackground   : UILabel!
    @IBOutlet weak var scrollFonts     : UIScrollView!
    @IBOutlet weak var vwFont1         : UIView!
    @IBOutlet weak var lblFont1        : UILabel!
    @IBOutlet weak var vwFont2         : UIView!
    @IBOutlet weak var lblFont2        : UILabel!
    @IBOutlet weak var vwFont3         : UIView!
    @IBOutlet weak var lblFont3        : UILabel!
    @IBOutlet weak var vwFont4         : UIView!
    @IBOutlet weak var lblFont4        : UILabel!
    @IBOutlet weak var vwFont5         : UIView!
    @IBOutlet weak var lblFont5        : UILabel!
    @IBOutlet weak var txtCaption      : UITextField!
    
    //MARK: - Variables and Properties
    let colors: [UIColor]                    = [
            .red,
            .blue,
            .green,
            .yellow,
            .orange,
            .purple,
            .cyan,
            .magenta,
            .brown,
            .systemPink
        ]
    let fonts: [UIFont]                      = [
            UIFont.systemFont(ofSize: 20),
            UIFont.boldSystemFont(ofSize: 20),
            UIFont.italicSystemFont(ofSize: 20),
            UIFont(name: "Helvetica", size: 20) ?? UIFont.systemFont(ofSize: 20),
            UIFont(name: "Arial", size: 20) ?? UIFont.systemFont(ofSize: 20),
            // Add more fonts as needed
        ]
    var outputURL              : URL?        = nil
    var player                 : AVPlayer!   = nil
    var typeSelected           : Int         = 0
    var initialTouchPoint      : CGPoint     = CGPoint(x: 0, y: 0)
    var initialFrame           : CGRect      = CGRect.zero

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
   
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
            let touchPoint = recognizer.location(in: self.view)
            
            switch recognizer.state {
            case .began:
                // Store initial touch point
                initialTouchPoint = touchPoint
            case .changed:
                // Calculate new frame based on the difference between the initial touch point and current touch point
                let deltaX = touchPoint.x - initialTouchPoint.x
                let deltaY = touchPoint.y - initialTouchPoint.y
                txtCaption.frame = CGRect(x: initialFrame.origin.x + deltaX,
                                         y: initialFrame.origin.y + deltaY,
                                         width: initialFrame.size.width,
                                         height: initialFrame.size.height)
            default:
                break
            }
        }
    
    @IBAction func ontapFontsChanging(_ sender: UIButton){
        if sender.tag == 0{
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 2
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 1
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 1
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 1
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 1
            txtCaption.font      = fonts[0]
        }
        else if sender.tag == 1{
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 1
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 2
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 1
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 1
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 1
            txtCaption.font      = fonts[1]
        }
        else if sender.tag == 2{
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 1
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 1
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 2
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 1
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 1
            txtCaption.font      = fonts[2]
        }
        else if sender.tag == 3{
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 1
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 1
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 1
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 2
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 1
            txtCaption.font      = fonts[3]
        }
        else {
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 1
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 1
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 1
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 1
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 2
            txtCaption.font      = fonts[4]
        }
    }
    
    @IBAction func ontapColorChanging(_ sender: UIButton){
        
        if sender.tag == 0 {
            typeSelected                 = 0
            if vwForeground.borderColor  == UIColor.white {
                vwForeground.borderWidth = 1
                vwForeground.borderColor = .white
            }
        }
        else{
            typeSelected                 = 1
            vwBackground.borderWidth     = 1
            vwBackground.borderColor     = .white
        }
    }
    
    @objc func ontapDone() {
        
        addStickerorTexttoVideo(textBgClr: .white
                                , textForeClr: .red
                                , fontNm: 0
                                , videoUrl: self.outputURL!
                                , watermarkText: "Usamasdfsada"
                                , imageName: ""
                                , position: 3) { url in
            DispatchQueue.main.async {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            }
        } failure: { msg in
            print(msg)
        }
    }
}

//MARK: - setup View {}
extension AddCaptionVC {
    
    func onLoad() {
        
        collectColors.register(ColorCCell.nib, forCellWithReuseIdentifier: ColorCCell.identifier)
        collectColors.delegate   = self
        collectColors.dataSource = self
        playVideo()
        NavigationRightBtn()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        txtCaption.addGestureRecognizer(panGesture)
        // Store initial frame of the textField
        initialFrame = txtCaption.frame
    }
    
    func onAppear() {
        
        showNavBar()
        removeNavBackbuttonTitle()
        lblFont1.font = fonts[0]
        lblFont2.font = fonts[1]
        lblFont3.font = fonts[2]
        lblFont4.font = fonts[3]
        lblFont5.font = fonts[4]
    }
    
    func playVideo() {
        
        if let url = outputURL {
             player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(playerLayer)
            view.bringSubviewToFront(collectColors)
            view.bringSubviewToFront(scrollFonts)
            view.bringSubviewToFront(txtCaption)
        }
    }
    
    func NavigationRightBtn() {
        
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ontapDone))
        btnDone.tintColor = .white
        navigationItem.rightBarButtonItem = btnDone
    }

}

//MARK: - setup Collection View {}
extension AddCaptionVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectColors.dequeueReusableCell(withReuseIdentifier: ColorCCell.identifier, for: indexPath) as? ColorCCell
        cell?.vwColor.backgroundColor = colors[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 32, height: 32)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if typeSelected                 == 0 {
            txtCaption.textColor        = colors[indexPath.row]
            vwForeground.borderWidth    = 2
            vwForeground.borderColor    = colors[indexPath.row]
            
        }
        else if typeSelected            == 1 {
            txtCaption.backgroundColor  = colors[indexPath.row]
            vwBackground.backgroundColor = colors[indexPath.row]
        }
        else{
            
        }
    }
}
