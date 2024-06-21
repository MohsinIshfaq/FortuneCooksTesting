//
//  AddCaptionVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/03/2024.
//

import UIKit
import AVFoundation
import AVKit

class AddCaptionVC: AudioViewController , UITextViewDelegate {

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
    @IBOutlet weak var txtCaption      : UITextView!
    @IBOutlet weak var btnDismiss      : UIButton!
    @IBOutlet weak var btnBackground   : UIButton!
    @IBOutlet weak var btnTrash        : UIButton!
    @IBOutlet weak var heightTxtView   : NSLayoutConstraint!
    
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
            UIFont(name: "TimesNewRomanPSMT", size: 20) ?? UIFont.systemFont(ofSize: 20),
            UIFont.systemFont(ofSize: 20)
            // Add more fonts as needed
        ]
    var outputURL              : URL?        = nil
    var player                 : AVPlayer!   = nil
    var typeSelected           : Int         = 0
    var initialTouchPoint      : CGPoint     = CGPoint(x: 0, y: 0)
    var initialFrame           : CGRect      = CGRect.zero
    var posotionTxtFld         : Int         = 1
    var txtBGcolor             : UIColor     = .clear
    var txtForcolor            : UIColor     = .white
    var fontNum                : Int         = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
        txtCaption.backgroundColor = .clear
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        
        txtCaption.backgroundColor = .clear
        txtCaption.text            = "Hello World"
        txtCaption.textColor       = .white
        txtCaption.font            = UIFont.systemFont(ofSize: 18)
        vwForeground.borderWidth   = 0.5
        vwForeground.borderColor   = .white
        vwBackground.backgroundColor = .clear
        vwBackground.borderWidth     = 0.5
        vwBackground.borderColor     = .white
        btnTrash.isHidden            = true
        lblBackground.textColor      = .white
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: self.view)
        
        switch recognizer.state {
        case .began:
            // Store initial touch point and initial frame
            initialTouchPoint = touchPoint
            initialFrame = txtCaption.frame
        case .changed:
            // Calculate new frame based on the difference between the initial touch point and current touch point
            let deltaX = touchPoint.x - initialTouchPoint.x
            let deltaY = touchPoint.y - initialTouchPoint.y
            txtCaption.frame = CGRect(x: initialFrame.origin.x + deltaX,
                                      y: initialFrame.origin.y + deltaY,
                                      width: initialFrame.size.width,
                                      height: initialFrame.size.height)
            
            // Determine the position of the text field based on the yAxis
            let viewHeight = self.view.bounds.height
            let spacing = viewHeight / 3 // Equal spacing
            
            let topThreshold = spacing // Top
            let bottomThreshold = viewHeight - spacing // Bottom
            let position: Int
            
            if touchPoint.y < topThreshold {
                position = 0 // Top
            } else if touchPoint.y > topThreshold && touchPoint.y < bottomThreshold {
                position = 1 // Center
            } else {
                position = 2 // Bottom
            }
            
            // Now you can use the 'position' variable as needed.
            print("Position: \(position)")
            self.posotionTxtFld = position
            
        default:
            break
        }
    }

    @IBAction func ontapFontsChanging(_ sender: UIButton){
        if sender.tag == 0{
            self.fontNum         =  0
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 2
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 0.5
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 0.5
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 0.5
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 0.5
            txtCaption.font      = fonts[0]
        }
        else if sender.tag == 1{
            self.fontNum         =  1
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 0.5
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 2
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 0.5
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 0.5
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 0.5
            txtCaption.font      = fonts[1]
        }
        else if sender.tag == 2{
            self.fontNum         =  2
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 0.5
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 0.5
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 2
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 0.5
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 0.5
            txtCaption.font      = fonts[2]
        }
        else if sender.tag == 3{
            self.fontNum         =  3
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 0.5
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 0.5
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 0.5
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 2
            vwFont5.borderColor  = .white
            vwFont5.cornerRadius = 8
            vwFont5.borderWidth  = 0.5
            txtCaption.font      = fonts[3]
        }
        else {
            self.fontNum         =  4
            vwFont1.borderColor  = .white
            vwFont1.cornerRadius = 8
            vwFont1.borderWidth  = 0.5
            vwFont2.borderColor  = .white
            vwFont2.cornerRadius = 8
            vwFont2.borderWidth  = 0.5
            vwFont3.borderColor  = .white
            vwFont3.cornerRadius = 8
            vwFont3.borderWidth  = 0.5
            vwFont4.borderColor  = .white
            vwFont4.cornerRadius = 8
            vwFont4.borderWidth  = 0.5
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
                vwForeground.borderColor = .ColorDarkBlue
                vwBackground.borderWidth = 0.5
                vwBackground.borderColor = .white
            }
        }
        else{
            vwForeground.borderWidth     = 0.5
            vwForeground.borderColor     = .white
            typeSelected                 = 1
            vwBackground.borderWidth     = 1
            vwBackground.borderColor     = .ColorDarkBlue
        }
    }
    
    @objc func handleDoubleTap() {
        print("Button double tapped!")
        vwBackground.backgroundColor = .clear
        txtCaption.backgroundColor   = .clear
    }
    
//    func addNewlineIfNeeded(to text: String, maxWordsPerLine: Int) -> String? {
//        let words = text.components(separatedBy: .whitespacesAndNewlines)
//        var newText = ""
//        var wordCount = 0
//        
//        for word in words {
//            if wordCount + 1 <= maxWordsPerLine {
//                newText += word + " "
//                wordCount += 1
//            } else {
//                newText += "\n" + word + " "
//                wordCount = 1
//            }
//        }
//        return "  " + newText.trimmingCharacters(in: .whitespacesAndNewlines) + " "
//    }
    
    func addNewlineIfNeeded(to text: String, textViewWidth: CGFloat, font: UIFont) -> String? {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        var newText = ""
        var currentLine = ""
        let spaceWidth = " ".size(withAttributes: [.font: font]).width

        for word in words {
            let wordWidth = word.size(withAttributes: [.font: font]).width
            let currentLineWidth = currentLine.size(withAttributes: [.font: font]).width

            if currentLineWidth + wordWidth + spaceWidth <= textViewWidth {
                if !currentLine.isEmpty {
                    currentLine += " " + word
                } else {
                    currentLine = word
                }
            } else {
                newText += currentLine + "\n"
                currentLine = word
            }
        }

        if !currentLine.isEmpty {
            newText += currentLine
        }

        return newText
    }

    
    @objc func longPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                // Long press gesture recognized
                print("Long press detected!")
                btnTrash.isHidden  = false
            }
        }

    @objc func ontapDone() {
       
        if txtCaption.text == "Hello world"{
            showToast(message: "Please change your caption", seconds: 2, clr: .red)
        }
        else{
          //  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startAnimating()
                if var string = addNewlineIfNeeded(to: txtCaption.text, textViewWidth: txtCaption.frame.width, font: txtCaption.font ?? UIFont.systemFont(ofSize: 17)) {
                    print(string)
                    self.addStickerorTexttoVideo(textBgClr: self.txtBGcolor
                                            , textForeClr: self.txtForcolor
                                            , fontNm: self.fontNum
                                            , videoUrl: self.outputURL!
                                            , watermarkText: string
                                            , imageName: ""
                                            , position: self.posotionTxtFld) { url in
                        DispatchQueue.main.async {
                            self.stopAnimating()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                UserManager.shared.finalURL  = url
                                if let url = UserManager.shared.finalURL {
                                    let player = AVPlayer(url: url)
                                    let playerViewController = AVPlayerViewController()
                                    playerViewController.player = player
                                    
                                    self.present(playerViewController, animated: true) {
                                        player.play()
                                    }
                                }
//                                self.showToast(message: "Caption added successfully.", seconds: 2, clr: .gray)
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                    self.stopAnimating()
//                                    self.popRoot()
//                                }
                            }
                        }
                    } failure: { msg in
                        print(msg)
                    }
                }
          //  }
        }
    }
}

//MARK: - setup View {}
extension AddCaptionVC {
    
    func onLoad() {
        
        self.outputURL           = UserManager.shared.finalURL
        collectColors.register(ColorCCell.nib, forCellWithReuseIdentifier: ColorCCell.identifier)
        collectColors.delegate   = self
        collectColors.dataSource = self
        playVideo()
        NavigationRightBtn()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        txtCaption.addGestureRecognizer(panGesture)
        // Store initial frame of the textField
        initialFrame = txtCaption.frame
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        btnBackground.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        txtCaption.addGestureRecognizer(longPressGesture)
        txtCaption.delegate = self
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
            view.bringSubviewToFront(btnDismiss)
            view.bringSubviewToFront(btnTrash)
        }
    }
    
    func NavigationRightBtn() {
        
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ontapDone))
        btnDone.tintColor = .white
        navigationItem.rightBarButtonItem = btnDone
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkIfTextViewWentToSecondLine(textView: textView)
    }
    
    func checkIfTextViewWentToSecondLine(textView: UITextView) {
        guard let font = textView.font else { return }
        
        // Calculate the width of the text view's visible content area
        let textViewWidth = textView.bounds.width - textView.textContainerInset.left - textView.textContainerInset.right
        
        // Calculate the width of the current text
        let textWidth = (textView.text as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).width
        
        // Calculate the number of lines needed for the text
        let numberOfLines = ceil(textWidth / textViewWidth)
        
        // Check if the number of lines is greater than 1
        if numberOfLines > 1 {
            print("TextView went to second line or more")
            // Increase the height of the text view by 40 points
            if textView.frame.height < textView.contentSize.height {
                textView.frame.size.height += 40
            }
        } else {
            print("TextView is within a single line")
        }
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
            self.txtForcolor            = colors[indexPath.row]
            
        }
        else if typeSelected            == 1 {
            txtCaption.backgroundColor  = colors[indexPath.row]
            self.txtBGcolor             = colors[indexPath.row]
            vwBackground.backgroundColor = .white
            lblBackground.textColor      = .black
        }
        else{
            
        }
    }
}

extension String {
    func size(withAttributes attrs: [NSAttributedString.Key: Any]) -> CGSize {
        return (self as NSString).size(withAttributes: attrs)
    }
}
