//
//  DetailViewController.swift
//  project1
//
//  Created by Антон Баскаков on 04.08.2024.
//

import CoreGraphics
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var selectedImageCount: Int?
    var selectedImageNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let selectedImageCount else { return }
        guard let selectedImageNumber else { return }
        title = "Picture \(selectedImageNumber) of \(selectedImageCount)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image  = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let imageSize = imageView.image?.size else { return }
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        let img = renderer.image { ctx in
            guard let image = imageView.image else { return }
            image.draw(at: .zero)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle,
                .backgroundColor: UIColor.white
            ]
            
            let attributedString = NSAttributedString(string: "From Storm Viewer", attributes: attrs)
            
            attributedString.draw(at: CGPoint(x: 5, y: 5))
        }
        
        guard let image = img.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        guard let imageName = selectedImage else {
            print("Unable to load image name")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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
