//
//  FilterCamViewCOntroller.swift
//  Resturants
//
//  Created by Coder Crew on 08/03/2024.
//

import Foundation
import AVFoundation
import GLKit
import UIKit

public protocol FilterCamViewControllerDelegate: class {
    func filterCamDidStartRecording(_ filterCam: FilterCamViewController)
    func filterCamDidFinishRecording(_ filterCame: FilterCamViewController)
    func filterCam(_ filterCam: FilterCamViewController, didFailToRecord error: Error)
    func filterCam(_ filterCam: FilterCamViewController, didFinishWriting outputURL: URL)
    func filterCam(_ filterCam: FilterCamViewController, didFocusAtPoint tapPoint: CGPoint)
}

open class FilterCamViewController: UIViewController, AVAudioRecorderDelegate {
    
    public weak var cameraDelegate             : FilterCamViewControllerDelegate?
    public var devicePosition                  = AVCaptureDevice.Position.back
    public var currentPosition                 = AVCaptureDevice.Position.back
    public var videoQuality                    = AVCaptureSession.Preset.high
    private let previewViewRect                : CGRect
    private var videoPreviewContainerView      : UIView!
    private var videoPreviewView               : GLKView!
    private var ciContext                      : CIContext!
    private var recorder                       : Recorder!
    private var videoPreviewViewBounds: CGRect = .zero
    private var fpsLabel                       : UILabel!
    private var secLabel                       : UILabel!
    var recordingSession                       : AVAudioSession!
    var audioRecorder                          : AVAudioRecorder!
    
    public var filters: [CIFilter] = [] {
        didSet {
            recorder.filters = filters
        }
    }
    
    public var hasTorch: Bool {
        return recorder.hasTorch
    }
    
    public var torchLevel: Float {
        set {
            recorder.torchLevel = newValue
        }
        get {
            return recorder.torchLevel
        }
    }
    
    public var shouldShowDebugLabels: Bool = false {
        didSet {
            fpsLabel.isHidden = !shouldShowDebugLabels
            secLabel.isHidden = !shouldShowDebugLabels
        }
    }
    
    private var isRecording: Bool {
        return recorder.assetWriter != nil
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    public init(previewViewRect: CGRect) {
        self.previewViewRect = previewViewRect
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        previewViewRect = UIScreen.main.bounds
        super.init(coder: aDecoder)
    }
    
    func muteAudio(_ isMuted: Bool) {
        recorder.muteAudio(isMuted)
    }
    
    func wannaHideView() {
        videoPreviewView.isHidden = true
    }
    func wannaShowView() {
        videoPreviewView.isHidden = false
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefault.isAuthenticated {
            view.backgroundColor = .clear
            videoPreviewContainerView = UIView(frame: previewViewRect)
            videoPreviewContainerView.backgroundColor = .black
            view.addSubview(videoPreviewContainerView)
            view.sendSubviewToBack(videoPreviewContainerView)
            
            // setup the GLKView for video/image preview
            guard let eaglContext = EAGLContext(api: .openGLES2) else {
                fatalError("Could not create EAGLContext")
            }
            if eaglContext != EAGLContext.current() {
                EAGLContext.setCurrent(eaglContext)
            }
            videoPreviewView = GLKView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: previewViewRect.height,
                                                     height: previewViewRect.width),
                                       context: eaglContext)
            videoPreviewContainerView.addSubview(videoPreviewView)
            
            // because the native video image from the back camera is in UIDeviceOrientationLandscapeLeft (i.e. the home button is on the right), we need to apply a clockwise 90 degree transform so that we can draw the video preview as if we were in a landscape-oriented view; if you're using the front camera and you want to have a mirrored preview (so that the user is seeing themselves in the mirror), you need to apply an additional horizontal flip (by concatenating CGAffineTransformMakeScale(-1.0, 1.0) to the rotation transform)
            videoPreviewView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            videoPreviewView.center = CGPoint(x: previewViewRect.width * 0.5, y: previewViewRect.height * 0.5)
            videoPreviewView.enableSetNeedsDisplay = false
            
            // bind the frame buffer to get the frame buffer width and height; the bounds used by CIContext when drawing to a GLKView are in pixels (not points), hence the need to read from the frame buffer's width and height; in addition, since we will be accessing the bounds in another queue (_captureSessionQueue), we want to obtain this piece of information so that we won't be accessing _videoPreviewView's properties from another thread/queue
            videoPreviewView.bindDrawable()
            videoPreviewViewBounds.size.width = CGFloat(videoPreviewView.drawableWidth)
            videoPreviewViewBounds.size.height = CGFloat(videoPreviewView.drawableHeight)
            
            // create the CIContext instance, note that this must be done after _videoPreviewView is properly set up
            ciContext = CIContext(eaglContext: eaglContext, options: [CIContextOption.workingColorSpace: NSNull()])
            recorder = Recorder(ciContext: ciContext, devicePosition: devicePosition, preset: videoQuality)
            recorder.delegate = self
            setupDebugLabels()
            addGestureRecognizers()
        }
        else{
            showAlertCOmpletion(withTitle: "", message: "Access to the profile screen is restricted due to authentication requirements.") { status in
                if status {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    // MARK: - Private
    // Modify the toggleCamera method to wait for configuration completion
    public func toggleCamera() {
        
        DispatchQueue.main.async {
            self.currentPosition = self.devicePosition
            
            // Add a delay before configuring the device
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.recorder.configureDevice(position: self.devicePosition) { success in
                    if success {
                        self.devicePosition = (self.devicePosition == .front) ? .back : .front
                    } else {
                        print("Failed to configure device")
                    }
                }
            }
        }
    }
    
    private func setupDebugLabels() {
        
        fpsLabel = UILabel()
        fpsLabel.isHidden = true
        view.addSubview(fpsLabel)
        fpsLabel.translatesAutoresizingMaskIntoConstraints = false
        fpsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        fpsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        fpsLabel.text = ""
        fpsLabel.textColor = .white
        secLabel = UILabel()
        secLabel.isHidden = true
        view.addSubview(secLabel)
        secLabel.translatesAutoresizingMaskIntoConstraints = false
        secLabel.leadingAnchor.constraint(equalTo: fpsLabel.leadingAnchor).isActive = true
        secLabel.topAnchor.constraint(equalTo: fpsLabel.bottomAnchor).isActive = true
        secLabel.text = ""
        secLabel.textColor = .white
    }
    
    private func addGestureRecognizers() {
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture(tap:)))
        singleTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTapGesture)
    }
    
    @objc private func singleTapGesture(tap: UITapGestureRecognizer) {
        
        let screenSize = view.bounds.size
        let tapPoint = tap.location(in: view)
        let x = tapPoint.y / screenSize.height
        let y = 1.0 - tapPoint.x / screenSize.width
        let focusPoint = CGPoint(x: x, y: y)
        recorder.focus(at: focusPoint)
        // call delegate function and pass in the location of the touch
        DispatchQueue.main.async {
            self.cameraDelegate?.filterCam(self, didFocusAtPoint: tapPoint)
        }
    }
    
    private func calculateDrawRect(for image: CIImage) -> CGRect {
        
        let sourceExtent = image.extent
        let sourceAspect = sourceExtent.size.width / sourceExtent.size.height
        let previewAspect = videoPreviewViewBounds.size.width / videoPreviewViewBounds.size.height
        // we want to maintain the aspect ratio of the screen size, so we clip the video image
        var drawRect = sourceExtent
        if sourceAspect > previewAspect {
            // use full height of the video image, and center crop the width
            drawRect.origin.x += (drawRect.size.width - drawRect.size.height * previewAspect) / 2.0
            drawRect.size.width = drawRect.size.height * previewAspect
        } else {
            // use full width of the video image, and center crop the height
            drawRect.origin.y += (drawRect.size.height - drawRect.size.width / previewAspect) / 2.0
            drawRect.size.height = drawRect.size.width / previewAspect
        }
        return drawRect
    }
    
    // MARK: - Public
    
    public func startRecording() {
        if !isRecording {
            recorder.startRecording()
        }
    }
    
    public func stopRecording() {
        if isRecording {
            recorder.stopRecording()
        }
    }
    func showAlertCOmpletion(withTitle title : String?, message : String, completion: ((_ status: Bool) -> Void)? = nil)
    
    {
        // Create Alert
        var dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            completion?( true)
        })
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            completion?( true)
        }
        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
       // dialogMessage.addAction(cancel)
        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
}

extension FilterCamViewController: RecorderDelegate {
    
    func recorderDidUpdate(drawingImage: CIImage) {
        
        let drawRect = calculateDrawRect(for: drawingImage)
        videoPreviewView.bindDrawable()
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        ciContext.draw(drawingImage, in: videoPreviewViewBounds, from: drawRect)
        videoPreviewView.display()
    }

    func recorderDidStartRecording() {
        
        secLabel?.text = "00:00"
        cameraDelegate?.filterCamDidStartRecording(self)
    }

    func recorderDidAbortRecording() {}

    func recorderDidFinishRecording() {
        
        cameraDelegate?.filterCamDidFinishRecording(self)
    }

    func recorderWillStartWriting() {
        
        secLabel?.text = "Saving..."
    }

    func recorderDidFinishWriting(outputURL: URL) {
        
        let fileName = UUID().uuidString
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName).appendingPathExtension("mov")
        Composer.compose(videoURL: outputURL, outputURL: tempURL) { [weak self] url, error in
            guard let strongSelf = self else { return }
            if let url = url {
                strongSelf.cameraDelegate?.filterCam(strongSelf, didFinishWriting: url)
            } else if let error = error {
                strongSelf.cameraDelegate?.filterCam(strongSelf, didFailToRecord: error)
            }
        }
    }

    func recorderDidUpdate(frameRate: Float) {
        
        fpsLabel?.text = NSString(format: "%.1f fps", frameRate) as String
    }

    func recorderDidUpdate(recordingSeconds: Int) {
        
        secLabel?.text = NSString(format: "%02lu:%02lu sec", recordingSeconds / 60, recordingSeconds % 60) as String
    }

    func recorderDidFail(with error: Error & LocalizedError) {
        
        cameraDelegate?.filterCam(self, didFailToRecord: error)
    }
}
