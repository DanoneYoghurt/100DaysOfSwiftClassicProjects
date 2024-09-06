//
//  DetailViewController.swift
//  milestone4
//
//  Created by Антон Баскаков on 06.09.2024.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image else { return }
        guard let name else { return }
        
        title = name
        imageView.image = image
        
        

    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
