//
//  AddORUpdateItemVC.swift
//  Resturants
//
//  Created by Coder Crew on 10/08/2024.
//

import UIKit

class AddORUpdateItemVC: UIViewController {

    @IBOutlet weak var imgItem       : UIImageView!
    @IBOutlet weak var txtName       : UITextField!
    @IBOutlet weak var txtDescrip    : UITextView!
    @IBOutlet weak var txtPrice      : UITextField!
    @IBOutlet weak var txtCurrency   : UITextField!
    @IBOutlet weak var txtMostLiked  : UITextField!
    @IBOutlet weak var txtListNumber : UITextField!
    @IBOutlet weak var txtGroup      : UITextField!
    var arr = [1,2,3]
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func ontapSave(_ sender: UIButton){
        
    }
    
    @IBAction func ontapGetImage(_ sender: UIButton){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate      = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType    = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func ontapCurrency(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtCurrency.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.currencies {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapMostLiked(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtMostLiked.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for i in 0 ..< arr.count {
            menuChildren.append(UIAction(title: "\(i)", handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }

    @IBAction func ontapListNumbr(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtListNumber.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for i in 0 ..< arr.count {
            menuChildren.append(UIAction(title: "\(i)", handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapGrp(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtGroup.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for i in 0 ..< arr.count {
            menuChildren.append(UIAction(title: "\(i)", handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
}

extension AddORUpdateItemVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.imgItem.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
