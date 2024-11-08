//
//  CameraLiveCapture.swift
//  Resturants
//
//  Created by Coder Crew on 07/03/2024.
//

import Foundation
import AVFoundation
import CoreImage

extension CIImage {
  func transformToOrigin(withSize size: CGSize) -> CIImage {
    let originX = extent.origin.x
    let originY = extent.origin.y
    let scaleX = size.width / extent.width
    let scaleY = size.height / extent.height
    let scale = max(scaleX, scaleY)
    return transformed(by: CGAffineTransform(translationX: -originX, y: -originY)).transformed(by: CGAffineTransform(scaleX: scale, y: scale))
  }
}

class CameraCapture: NSObject {
    typealias Callback = (CIImage?) -> ()
    
    private let position: AVCaptureDevice.Position
    private let callback: Callback
    private let session = AVCaptureSession()
    private let bufferQueue = DispatchQueue(label: "someLabel", qos: .userInitiated)
    
    init(position: AVCaptureDevice.Position = .front, callback: @escaping Callback) {
        self.position = position
        self.callback = callback
        
        super.init()
        configureSession()
    }
    
    func start() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    func stop() {
        session.stopRunning()
    }
    
    private func configureSession() {
        session.sessionPreset = .hd1280x720
        
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: position)
        guard let camera = discovery.devices.first, let input = try? AVCaptureDeviceInput(device: camera) else {
            // Error handling
            return
        }
        session.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: bufferQueue)
        session.addOutput(output)
    }
}

extension CameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        DispatchQueue.main.async {
            let image = CIImage(cvImageBuffer: imageBuffer)
            self.callback(image.transformed(by: CGAffineTransform(rotationAngle: 3 * .pi / 2)))
        }
    }
}



import MetalKit
import CoreImage

class MetalRenderView: MTKView {
    private lazy var commandQueue: MTLCommandQueue? = {
        return device?.makeCommandQueue()
    }()
    
    private lazy var ciContext: CIContext? = {
        guard let device = device else { return nil }
        return CIContext(mtlDevice: device)
    }()
    
    private var image: CIImage? {
        didSet {
            renderImage()
        }
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        
        if super.device == nil {
            fatalError("Metal is not supported by this device")
        }
        framebufferOnly = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setImage(_ image: CIImage?) {
        guard let image = image else { return }
        self.image = image
    }
    
    private func renderImage() {
        guard let image = image,
              let currentDrawable = currentDrawable,
              let ciContext = ciContext else { return }
        
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let destination = CIRenderDestination(width: Int(drawableSize.width),
                                              height: Int(drawableSize.height),
                                              pixelFormat: .rgba8Unorm,
                                              commandBuffer: commandBuffer) { () -> MTLTexture in
            return currentDrawable.texture
        }
        
        do {
            try ciContext.startTask(toRender: image.transformToOrigin(withSize: drawableSize), to: destination)
        } catch {
            // Error handling
        }
        
        commandBuffer?.present(currentDrawable)
        commandBuffer?.commit()
        draw()
    }
}



//metalView = MetalRenderView(frame: view.bounds, device: MTLCreateSystemDefaultDevice())
//view.addSubview(metalView)
//
//cameraCapture = CameraCapture(position: .front, callback: { image in
//    guard let image = image else { return }
//    
//    // Define the filter names
//    let filterNames = ["CIThermal", "CIXRay", "CIMotionBlur"]
//    
//    // Choose a random filter name from the array
//    let randomFilterName = filterNames.randomElement() ?? ""
//    
//    // Create the filter using the random filter name
//    if let filter = CIFilter(name: randomFilterName) {
//        // Set defaults for the filter
//        filter.setDefaults()
//        
//        // Set the input image for the filter
//        filter.setValue(image, forKey: kCIInputImageKey)
//        
//        // Get the output image from the filter
//        if let outputImage = filter.outputImage {
//            // Update the image view with the filtered image
//            DispatchQueue.main.async {
//                self.metalView.setImage(outputImage.cropped(to: image.extent))
//            }
//        }
//    }
//})
//
//cameraCapture?.start()
