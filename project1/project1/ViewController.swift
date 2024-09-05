//
//  ViewController.swift
//  project1
//
//  Created by Антон Баскаков on 02.08.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var timesShown = [Int]()

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
                    if ((self?.timesShown.isEmpty) != nil) {
                        self?.timesShown.append(0)
                    }
                }
            }
            
            if let savedData = UserDefaults.standard.object(forKey: "timesShown") as? Data {
                do {
                    self?.timesShown = try JSONDecoder().decode([Int].self, from: savedData)
                } catch {
                    print("failed to load")
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
        cell.detailTextLabel?.text = "Times shown: \(timesShown[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timesShown[indexPath.row] += 1
        save()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageCount = pictures.count
            vc.selectedImageNumber = Int(pictures.firstIndex(of: pictures[indexPath.row]) ?? 0) + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        if let savedData = try? JSONEncoder().encode(timesShown) {
            UserDefaults.standard.setValue(savedData, forKey: "timesShown")
        } else {
            print("Failed to save")
        }
    }

}

