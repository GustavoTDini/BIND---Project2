//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Gustavo Dini on 29/12/18.
//  Copyright © 2018 Gustavo Dini. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: constants
    
    let TOP_TEXT_PLACEHOLDER = "TOP"
    let BOTTOM_TEXT_PLACEHOLDER = "BOTTOM"
    
    let memeTextAttributes:[NSAttributedString.Key:Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue):UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue):-4.0
    ]
    
    // MARK: variables
    
    var id = 0
    
    var currentMeme: Meme!
    
    var editingCurrentMeme: Bool!
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagesButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    var navBar: UINavigationBar!
    var saveButton: UIBarButtonItem!
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar = self.navigationController?.navigationBar
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveMeme))
        self.navigationItem.rightBarButtonItem  = saveButton
        self.navigationItem.title = nil
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setMemeTextStyle(toTextField: topTextField)
        setMemeTextStyle(toTextField: bottomTextField)
        
        if (editingCurrentMeme){
            setMeme(reset: false, selectImage: true, loadMeme: true)
        } else {
            setMeme(reset: true, selectImage: false, loadMeme: false)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: IBActions

    @IBAction func openCamera(_ sender: Any) {
        openImagePicker(_: .camera)
    }
    
    @IBAction func openImages(_ sender: Any) {
        openImagePicker(_: .photoLibrary)
    }
    
    
    // MARK: Keyboard Notification Functions
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isEditing){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: ImagePicker Functions
    
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            memeImageView.image = image
            setMeme(reset: false, selectImage: true, loadMeme: false)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: Generate & Save Functions
    
    func save(_ memeImage: UIImage) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        if (editingCurrentMeme){
            currentMeme = Meme(id: id , topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memeImage)
            appDelegate.memes[id] = currentMeme
        } else {
            id = appDelegate.memes.count
            currentMeme = Meme(id: id , topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memeImage)
            appDelegate.memes.append(currentMeme)
        }
    }
    
    func generateMemedImage() -> UIImage {
        hideShowBars(isHidden: true)
        // Render view to an image
        UIGraphicsBeginImageContext(getCropRect().size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cgMemeImage = memedImage.cgImage!.cropping(to: getCropRect())
        let memedImageCroped: UIImage = UIImage(cgImage: cgMemeImage!)
        hideShowBars(isHidden: false)
        return memedImageCroped
    }
    
    @IBAction func saveMeme(_ sender: Any) {
        if (topTextField.text != TOP_TEXT_PLACEHOLDER && bottomTextField.text != TOP_TEXT_PLACEHOLDER){
            let memeViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
            let memedImage = generateMemedImage()
            save(memedImage)
            memeViewController.meme = currentMeme
            
            self.navigationController!.pushViewController(memeViewController, animated: true)
        }

    }

    
    
    
    // MARK: Modify Views Functions
    
    func setMeme(reset: Bool, selectImage: Bool, loadMeme: Bool){
        if (reset){
            memeImageView.image = nil
            topTextField.text = TOP_TEXT_PLACEHOLDER
            bottomTextField.text = BOTTOM_TEXT_PLACEHOLDER
        } else if (loadMeme){
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            currentMeme = appDelegate.memes[id]
            memeImageView.image = currentMeme.originalImage
            topTextField.text = currentMeme.topText
            bottomTextField.text = currentMeme.bottomText
        }
        saveButton.isEnabled = selectImage
        topTextField.isEnabled = selectImage
        bottomTextField.isEnabled = selectImage
        bottomTextField.textAlignment = .center
    }
    
    func hideShowBars(isHidden: Bool){
        navBar.isHidden = isHidden
        toolBar.isHidden = isHidden
    }
    
    // MARK: TextField Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Erase the default text when editing
        if textField == topTextField && textField.text == "TOP" {
            textField.text = ""
            
        } else if textField == bottomTextField && textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // MARK: Other Functions
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func setMemeTextStyle(toTextField textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        textField.delegate = self
    }
    
    func getCropRect() -> CGRect {
        let height = self.view.frame.height
        let width = self.view.frame.width
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            navBar.frame.height
        let bottonBarHeight = toolBar.frame.height
        return CGRect(x: 0, y: topBarHeight, width: width, height: height - bottonBarHeight)
    }
    
}

