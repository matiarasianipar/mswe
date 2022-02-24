//
//  DetailViewController.swift
//  Quiz
//
//  Created by Matiara Sianipar on 11/30/21.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CanReceive {

    @IBOutlet var questionField: UITextField!
    @IBOutlet var answerField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var clearButton: UIButton!
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    var row = 0
    var question: Question! {
        didSet {
            navigationItem.title = question.question
        }
    }
    var imageStore: ImageStore!
    
    @IBAction func removeImage (_ sender: UIButton) {
        imageView.image = nil
    }
    
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
            
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            
            imagePicker.popoverPresentationController?.barButtonItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType)
    
    -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        check for edited image
        if let image = info[.editedImage] as? UIImage {
            self.imageView.image = image
            //        Store image in ImageStore for item's key
                    imageStore.setImage(image, forKey: question.questionKey)
                    
            //        Put image on screen in image view
                    imageView.image = image
        }
//        Get picked image from info dictionary
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = image
            //        Store image in ImageStore for item's key
                    imageStore.setImage(image, forKey: question.questionKey)
                    
            //        Put image on screen in image view
                    imageView.image = image
        }
                

        
//        Take image picker off screen - you must call dismiss method
        dismiss(animated: true, completion: nil)
        
    }
    
    

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
//        formatter.dateFormat = "mm/dd/yyyy"
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if row == -1 { // add new question
            questionField.text = ""
            answerField.text = ""
            dateLabel.text = formatter.string(from: question.dateCreated)
        }
        else { // edit exist question
            questionField.text = question.question
            answerField.text = String(question.correctAnswers)
            dateLabel.text = formatter.string(from: question.dateCreated)
            
//        Get item key
            let key = question.questionKey
            
//            if there is associated image with item, display on image view
            let imageToDisplay = imageStore.image(forKey: key)
            imageView.image = imageToDisplay
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        clear first responder
        view.endEditing(true)
        
        
//        "Save" changes to question
//        new question
        question.question = questionField.text ?? ""
        question.correctAnswers = Int(answerField.text!) ?? 0

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func passDataBack(data: UIImage, graph: [Line]) {
        imageStore.setImage(data, forKey: question.questionKey)
        question.graph = graph
        imageView.image = data
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "drawIdentifier" {
            
            let secondVC = segue.destination as! DrawViewController
            secondVC.graph = question.graph
            secondVC.delegate = self
        }
    }
}

