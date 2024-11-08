//
//  VideoEditor.swift
//  Resturants
//
//  Created by Coder Crew on 02/03/2024.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices
import AVKit
import Photos

class VideoEditor: NSObject {

//    func applyFilter(inputImage: CIImage , filterName: String) -> CIImage? {
//        let parameters = [
//            kCIInputImageKey: inputImage
//        ]
//        let filter = CIFilter(name: "Normal", parameters: parameters)
//        return filter?.outputImage
//    }
    
    func createFilteredImage(filterName: String, image: UIImage) -> UIImage {
        var image1: UIImage? = nil
        let context = CIContext(options: nil)
        if(filterName == UserManager.shared.filterNameList[0]){
            return image1!
        }
        // 1 - create source image
        let sourceImage = CIImage(image: image)
        
        // 2 - create filter using name
        let filter = CIFilter(name: filterName)
        filter?.setDefaults()
        
        // 3 - set source image
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        // 4 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        
        // 5 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(cgImage: outputCGImage!, scale: image.scale, orientation: image.imageOrientation)
        
        return filteredImage
    }
}
