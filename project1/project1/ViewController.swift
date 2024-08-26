//
//  ViewController.swift
//  project1
//
//  Created by Антон Баскаков on 02.08.2024.
//

import UIKit

class ViewController: UITableViewController {
    
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
            self?.tableView.reloadData()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["https://apps.apple.com/ru/app/apple-developer/id640199958"], applicationActivities: [])
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageCount = pictures.count
            vc.selectedImageNumber = Int(pictures.firstIndex(of: pictures[indexPath.row]) ?? 0) + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

