//
//  DetailViewController.swift
//  milestone1
//
//  Created by Антон Баскаков on 09.08.2024.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        guard let imageName = selectedImage?.replacingOccurrences(of: "@3x.png", with: "").capitalized else {
            print("Unable to load name")
            return
        }
        
        let avc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
