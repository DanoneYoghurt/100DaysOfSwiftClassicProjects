//
//  ViewController.swift
//  project1
//
//  Created by Антон Баскаков on 02.08.2024.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global().async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            
            for item in items {
                if item.hasPrefix("nssl") {
                    self?.pictures.append(item)
                }
            }
        }
        
        pictures.sort()
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["https://apps.apple.com/ru/app/apple-developer/id640199958"], applicationActivities: [])
        present(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell else {
            fatalError("Unable to dequeue CollectionViewCell")
        }
        cell.imageView.image = UIImage(named: pictures[indexPath.row])
        cell.name.text = pictures[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageCount = pictures.count
            vc.selectedImageNumber = Int(pictures.firstIndex(of: pictures[indexPath.row]) ?? 0) + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

