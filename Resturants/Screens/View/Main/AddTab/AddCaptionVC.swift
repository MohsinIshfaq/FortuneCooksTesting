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
    var posotionTxtFld         : CGFloat     = 5
    var xPosition              : CGFloat     = 1
    var txtBGcolor             : UIColor     = .clear
    var txtForcolor            : UIColor     = .white
    var fontNum                : Int         = 0
    var totalTime              : Float       = 0.0 // Total time in seconds
    
    let placeholder                        = "Enter Caption..."
    let placeholderColor                   = UIColor.lightGray
    var delegate : AudioRecordDelegate?    = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
       // txtCaption.backgroundColor = .clear
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
            var newX = initialFrame.origin.x + deltaX
            var newY = initialFrame.origin.y + deltaY
            
            // Get the boundaries of the parent view
            let safeAreaInsets = self.view.safeAreaInsets
            let maxX = self.view.bounds.width - initialFrame.size.width
            let maxY = self.view.bounds.height - initialFrame.size.height - safeAreaInsets.bottom
            
            // Ensure the new frame stays within the bounds of the parent view's safe area
            newX = max(0, min(newX, maxX))
            newY = max(safeAreaInsets.top, min(newY, maxY))
            
            txtCaption.frame = CGRect(x: newX,
                                      y: newY,
                                      width: initialFrame.size.width,
                                      height: initialFrame.size.height)
            
            let viewHeight = maxY
            let ySpacing = viewHeight / 12 // Equal spacing for y-axis
            let yPosition: Int
            
            if touchPoint.y < ySpacing {
                yPosition = 0 // Topmost
            } else if touchPoint.y < 2 * ySpacing {
                yPosition = 1 // Second position
            } else if touchPoint.y < 3 * ySpacing {
                yPosition = 2 // Third position
            } else if touchPoint.y < 4 * ySpacing {
                yPosition = 3 // Fourth position
            } else if touchPoint.y < 5 * ySpacing {
                yPosition = 4 // Fifth position
            } else if touchPoint.y < 6 * ySpacing {
                yPosition = 5 // Sixth position
            } else if touchPoint.y < 7 * ySpacing {
                yPosition = 6 // Seventh position
            } else if touchPoint.y < 8 * ySpacing {
                yPosition = 7 // Eighth position
            } else if touchPoint.y < 9 * ySpacing {
                yPosition = 8 // Ninth position
            } else if touchPoint.y < 10 * ySpacing {
                yPosition = 9 // Tenth position
            } else if touchPoint.y < 11 * ySpacing {
                yPosition = 10 // Eleventh position
            } else {
                yPosition = 11 // Bottommost
            }
            
            //            let viewWidth = self.view.bounds.width
            //            let threshold: CGFloat = 10 // Threshold value to consider the view as attached to the edge
            //            
            //            let xPosition: Int
            //            if newX <= threshold {
            //                xPosition = 0 // Attached to leading side
            //            } else if newX >= maxX - threshold {
            //                xPosition = 2 // Attached to trailing side
            //            } else {
            //                xPosition = 1 // Center
            //            }
            
            let viewWidth = self.view.bounds.width
            let xSpacing = viewWidth / 6 // Divided into six segments
            
            let xPosition: Int
            
            if touchPoint.x < xSpacing {
                xPosition = 0 // Leading edge
            } else if touchPoint.x < 2 * xSpacing {
                xPosition = 1 // Leading center
            } else if touchPoint.x < 3 * xSpacing {
                xPosition = 2 // Center-left
            } else if touchPoint.x < 4 * xSpacing {
                xPosition = 3 // Center
            } else if touchPoint.x < 5 * xSpacing {
                xPosition = 4 // Center-right
            } else {
                xPosition = 5 // Trailing edge
            }
            
            // Use the exact x and y coordinates for direct positioning
            self.posotionTxtFld = CGFloat(yPosition)
            self.xPosition = CGFloat(newX)
            
            print("Y Position: \(self.posotionTxtFld)")
            print("X Position: \(self.xPosition)")
            
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
    
    func addNewlineIfNeeded(to text: String, textViewWidth: CGFloat, font: UIFont) -> String? {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        var newText = ""
        var currentLine = ""
        let spaceWidth = " ".size(withAttributes: [.font: font]).width
        
        for word in words {
            let wordWidth = word.size(withAttributes: [.font: font]).width
            let currentLineWidth = currentLine.size(withAttributes: [.font: font]).width
            
            if wordWidth > textViewWidth {
                // Break the word into smaller parts that fit the textViewWidth
                var remainingWord = word
                while remainingWord.size(withAttributes: [.font: font]).width > textViewWidth {
                    var part = ""
                    for char in remainingWord {
                        let testPart = part + String(char)
                        if testPart.size(withAttributes: [.font: font]).width > textViewWidth {
                            break
                        }
                        part = testPart
                    }
                    if !part.isEmpty {
                        newText += part + "\n"
                        remainingWord = String(remainingWord.dropFirst(part.count))
                    } else {
                        break
                    }
                }
                newText += remainingWord + "\n"
                currentLine = ""
            } else {
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

    @objc func customButtonTapped() {
        // Handle button tap
        print("Custom button tapped!")
        /*popup*/()
        delegate?.popupfromAudioRecordVC(elapsedTime: self.totalTime, totalTime: self.totalTime)
    }
    
    @objc func ontapDone() {
        
        if txtCaption.text == "Enter Caption..."{
            showToast(message: "Please add your caption", seconds: 2, clr: .red)
        }
        else{
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startAnimating()
            if var string = addNewlineIfNeeded(to: txtCaption.text, textViewWidth: txtCaption.frame.width - 10, font: txtCaption.font ?? UIFont.systemFont(ofSize: 17)) {
                print(string)
                self.addStickerorTexttoVideo(textBgClr: self.txtBGcolor
                                             , textForeClr: self.txtForcolor
                                             , fontNm: self.fontNum
                                             , videoUrl: self.outputURL!
                                             , watermarkText: string
                                             , imageName: ""
                                             , position: self.posotionTxtFld, xPosition: self.xPosition) { url in
                    //self.getVideoDuration(from: url) { endtime in
                    //                            if endtime != nil {
                    //
                    //                                self.trimVideo(sourceURL: url, startTime: 1 , endTime: endtime!) { url in
                    //                                    DispatchQueue.main.async {
                    //                                        self.stopAnimating()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        UserManager.shared.finalURL  = url
                        //if let url = UserManager.shared.finalURL {
                        //                                                let player = AVPlayer(url: url)
                        //                                                let playerViewController = AVPlayerViewController()
                        //                                                playerViewController.player = player
                        //
                        //                                                self.present(playerViewController, animated: true) {
                        //                                                    player.play()
                        //                                                }
                        //                                            }
                        self.showToast(message: "Caption added successfully.", seconds: 2, clr: .gray)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.stopAnimating()
                            self.popRoot()
                        }
                    }
                } failure: { error in
                    self.showToast(message: error ?? "", seconds: 2, clr: .red)
                }
                //  }
            }
        }
    }
}

extension AddCaptionVC {

    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewWidth(textView)
        checkIfTextViewWentToSecondLine(textView: textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }
    
    private func adjustTextViewWidth(_ textView: UITextView) {
        let maxWidth: CGFloat = 280.0
        let size = textView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: textView.frame.height))
        var newWidth = size.width
        
        if newWidth > maxWidth {
            newWidth = maxWidth
        }
        
        // Update the text view's width constraint
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                constraint.constant = newWidth
            }
        }
        
        // Update the frame directly if no width constraint is set
        if textView.constraints.isEmpty {
            var frame = textView.frame
            frame.size.width = newWidth
            textView.frame = frame
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
        setupPlaceholder()
    }
    func setupPlaceholder() {
        txtCaption.text      = placeholder
        txtCaption.textColor = placeholderColor
    }
    func onAppear() {
        showNavBar()
        removeNavBackbuttonTitle()
        lblFont1.font = fonts[0]
        lblFont2.font = fonts[1]
        lblFont3.font = fonts[2]
        lblFont4.font = fonts[3]
        lblFont5.font = fonts[4]
        hideNavBackButton()
        NavBackButton()
    }
    
    func NavBackButton() {
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        customButton.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        let customBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customBarButtonItem
    }
    func playVideo() {
        if let url = outputURL {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = view.bounds
            playerLayer.videoGravity = .resizeAspect
            view.layer.addSublayer(playerLayer)
            view.bringSubviewToFront(collectColors)
            view.bringSubviewToFront(scrollFonts)
            view.bringSubviewToFront(txtCaption)
            view.bringSubviewToFront(btnDismiss)
            view.bringSubviewToFront(btnTrash)
        }
    }
    func printButtonEdges() {
        let leadingEdge = txtCaption.frame.origin.x
        let trailingEdge = txtCaption.frame.origin.x + txtCaption.frame.size.width
        print("Leading edge: \(leadingEdge)")
        self.xPosition      = leadingEdge
        self.posotionTxtFld = trailingEdge
        print("Trailing edge: \(trailingEdge)")
    }
    
    func NavigationRightBtn() {
        
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ontapDone))
        btnDone.tintColor = .white
        navigationItem.rightBarButtonItem = btnDone
    }
    
    func checkIfTextViewWentToSecondLine(textView: UITextView) {
        guard let font = textView.font else { return }
        
        // Calculate the width of the text view's visible content area
        let textViewWidth = textView.bounds.width - textView.textContainerInset.left - textView.textContainerInset.right
        
        // Calculate the height of the current text
        let textHeight = (textView.text as NSString).boundingRect(
            with: CGSize(width: textViewWidth, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).height
        
        // Calculate the total height needed, including padding
        let totalHeight = textHeight + textView.textContainerInset.top + textView.textContainerInset.bottom
        
        // Adjust the height of the text view
        if textView.frame.height != totalHeight {
            textView.frame.size.height = totalHeight
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
