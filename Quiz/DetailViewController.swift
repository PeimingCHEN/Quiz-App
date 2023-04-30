//
//  DetailViewController.swift
//  Quiz
//
//  Created by Peiming Chen on 12/1/22.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var questionField: UITextField!
    @IBOutlet var answerField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        // create an alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Setting the modal presentation style
        alertController.modalPresentationStyle = .popover
        
        // Indicating where the popover should point
        alertController.popoverPresentationController?.barButtonItem = sender
        
        // Checking whether the device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Adding actions to the action sheet
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil) // Presenting the image picker controller
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction
                = UIAlertAction(title: "Photo Library", style: .default) { _ in
                    let imagePicker = self.imagePicker(for: .photoLibrary)
                    // Presenting the photo library in a popover
                    imagePicker.modalPresentationStyle = .popover
                    imagePicker.popoverPresentationController?.barButtonItem = sender
                    self.present(imagePicker, animated: true, completion: nil) // Presenting the image picker controller
        }
        alertController.addAction(photoLibraryAction)
        
        if imageView.image != nil {
            // edit the image
            let editAction
                    = UIAlertAction(title: "Delete Photo", style: .default) { _ in
                        self.imageStore.deleteImage(forKey: self.item.imageKey)
                        self.imageView.image = nil
            }
            alertController.addAction(editAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Presenting the view controller modally
        present(alertController, animated: true, completion: nil)
    }
    
    var item: NumQuestion! {
        didSet {
            navigationItem.title = item.question
        }
    }
    var imageStore: ImageStore!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        questionField.text = item.question
        answerField.text = "\(item.answer)"
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.imageKey
        
        // If there is an associated image with the item, display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    
    // update the item values
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Clear first responder
        view.endEditing(true)

        // "Save" changes to item
        item.question = questionField.text ?? ""
        if let answerText = answerField.text,
            let answer = Float(answerText) {
            item.answer = answer
        } else {
                item.answer = 0
            }
    }
    
    // Dismissing the keyboard upon tapping Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Adding an image picker controller creation method
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self // Assigning the image picker controller delegate
        return imagePicker
    }
    
    // Accessing the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.imageKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen - you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "drawImage":
            let drawViewController
                    = segue.destination as! DrawViewController
            drawViewController.item = item
            drawViewController.imageStore = imageStore
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
