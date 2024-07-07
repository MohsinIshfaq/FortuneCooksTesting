//
//  BaseClass.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation
import UIKit

class BaseClass : UIViewController {

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
    
    func logoutApp() {
     
    }
    
    func handlingToggle(txtPassword : UITextField , toggle : UIButton){

        if txtPassword.isSecureTextEntry == false {

            txtPassword.isSecureTextEntry = true
            toggle.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        else if txtPassword.isSecureTextEntry == true {

            txtPassword.isSecureTextEntry = false
            toggle.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
    
    func share(Copied:URL) {
       
        let text = Copied
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        // Create the data for the QR code
        guard let data = string.data(using: String.Encoding.ascii) else {
            return nil
        }
        // Create a QR code filter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        // Set the input data for the filter
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image from the filter
        guard let qrImage = qrFilter.outputImage else {
            return nil
        }
        // Scale the image to a larger size to improve visibility (optional)
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        // Convert the Core Image to a UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func copyButtonTapped(string : String) {
        
        let stringToCopy = string
        UIPasteboard.general.string = stringToCopy
    }
}
