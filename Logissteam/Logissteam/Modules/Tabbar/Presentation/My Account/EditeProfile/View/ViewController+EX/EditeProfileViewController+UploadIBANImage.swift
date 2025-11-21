//
//  EditeProfileViewController+UploadIBANImage.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 02/09/2024.
//

import Foundation
import UIKit

import UniformTypeIdentifiers
import MobileCoreServices // For iOS 13

extension EditeProfileViewController {
    
    // Function to open the PDF picker
    func openPDFPicker() {
        let documentPicker: UIDocumentPickerViewController
        
        if #available(iOS 14.0, *) {
            // Use UTType.pdf for iOS 14 and above
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        } else {
            // Use kUTTypePDF for iOS 13
            let pdfUTType = String(kUTTypePDF)
            documentPicker = UIDocumentPickerViewController(documentTypes: [pdfUTType], in: .import)
        }
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        // Present the document picker
        present(documentPicker, animated: true, completion: nil)
    }
    
    func OpenCameraORGallary() {
        let alertController = UIAlertController(title: "Choose Photo From".localized, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            self.chooseImagePickerAction(source: .camera)
        }
        
        let photoLibAction = UIAlertAction(title: "Library".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            self.chooseImagePickerAction(source: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
}

extension EditeProfileViewController: UIDocumentPickerDelegate {
    
    // Delegate method called when a document is picked
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        // Extract the file name from the URL
        let fileName = selectedFileURL.lastPathComponent
        print("File Name Is: \(fileName)")
        
        // Handle the selected PDF file
        print("Selected PDF file URL: \(selectedFileURL)")
        
        // You can now use the URL to read the file data, upload it, etc.
        do {
            let data = try Data(contentsOf: selectedFileURL)
            // Process the PDF data as needed
            print("PDF data size: \(data.count) bytes")
            print("PDF data: \(data)")
            ibanData = data
        } catch {
            print("Error reading PDF file: \(error.localizedDescription)")
        }
    }
    
    // Delegate method called when the document picker is cancelled
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }
    
}

extension EditeProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.allowsEditing = true
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let img = info[convertFromUIImagePickerControllerInfoKey(.editedImage)] as? UIImage
        ibanData = img?.jpegData(compressionQuality: 0.5)
        print(ibanData ?? Data())
        ibanImage.image = img
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value)} )
        
    }
    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        
        return input.rawValue
        
    }
    
}
