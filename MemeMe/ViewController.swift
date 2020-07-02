//
//  ViewController.swift
//  MemeMe
//
//  Created by Felipe Chun on 6/29/20.
//  Copyright © 2020 Felipe Chun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    var meme: Meme? = nil

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIButton!
    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -6
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: set delegates on top and bottom text fields
        
        topText.delegate = self
        bottomText.delegate = self
        
        // MARK: set text attributes
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        // MARK: set initial text on top and bottom text fields
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.textAlignment = NSTextAlignment.center
        bottomText.textAlignment = NSTextAlignment.center
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Image Picker functions

    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let cameraImagePicker = UIImagePickerController()
        cameraImagePicker.delegate = self
        cameraImagePicker.sourceType = .camera
        present(cameraImagePicker, animated: true, completion: nil)
    }
    
    // MARK: Text field functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 && self.topText.text == "TOP" {
            self.topText.text = ""
        }
        if textField.tag == 2 && self.bottomText.text == "BOTTOM" {
            self.bottomText.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        self.toolbar.isHidden = true
        self.navBar.isHidden = true

        // take "screenshot" of the view
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.toolbar.isHidden = false
        self.navBar.isHidden = false

        return memedImage
    }
    
    func save() -> Meme {
        let meme = Meme(
            topText: topText.text!,
            bottomText: bottomText.text!,
            originalImage: imagePickerView.image!,
            memedImage: generateMemedImage()
        )
        return meme
    }
    
    @IBAction func share(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        let shareImageActivityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareImageActivityVC.completionWithItemsHandler = {
            (
            activityType: UIActivity.ActivityType?,
            completed: Bool,
            arrayReturnedItems: [Any]?,
            error: Error?
            ) in
            if completed {
                self.meme = self.save()
                return
            }
            if let shareError = error {
                print("error: \(shareError.localizedDescription)")
            }
        }
        
        self.present(shareImageActivityVC, animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
}

