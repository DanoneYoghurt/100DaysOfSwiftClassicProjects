//
//  ViewController.swift
//  milestone9
//
//  Created by Антон Баскаков on 19.10.2024.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Maker"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePicture))
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        imageView.image = image
    }

    @objc func sharePicture() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        
        let vc = UIActivityViewController(activityItems: [imageData], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    @IBAction func setTopTextTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Set Top Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = ac.textFields?.first?.text else { return }
            
            guard let importedPicture = self.imageView.image else { return }
            
            let renderer = UIGraphicsImageRenderer(size: importedPicture.size)
            
            let img = renderer.image { ctx in
                let image = self.imageView.image!
                image.draw(at: .zero)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 80),
                    .paragraphStyle: paragraphStyle,
                    .backgroundColor: UIColor.black
                ]
                
                let attributedString = NSAttributedString(string: text, attributes: attrs)
                
                attributedString.draw(with: CGRect(x: 0 , y: 10, width: importedPicture.size.width, height: importedPicture.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
            }
            
            self.imageView.image = img
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    @IBAction func setBottomTextTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Set Bottom Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = ac.textFields?.first?.text else { return }
            
            guard let importedPicture = self.imageView.image else { return }
            
            let renderer = UIGraphicsImageRenderer(size: importedPicture.size)
            
            let img = renderer.image { ctx in
                let image = self.imageView.image!
                image.draw(at: .zero)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 80),
                    .paragraphStyle: paragraphStyle,
                    .backgroundColor: UIColor.black
                ]
                
                let attributedString = NSAttributedString(string: text, attributes: attrs)
                
                attributedString.draw(with: CGRect(x: 0 , y: importedPicture.size.height - attributedString.size().height, width: importedPicture.size.width, height: importedPicture.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
            }
            
            self.imageView.image = img
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
}

