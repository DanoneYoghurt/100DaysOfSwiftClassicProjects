//
//  ViewController.swift
//  milestone4
//
//  Created by Антон Баскаков on 06.09.2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var images = [Image]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Notes"
        
        let defaults = UserDefaults.standard
        
        if let savedImages = defaults.object(forKey: "images") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                images = try jsonDecoder.decode([Image].self, from: savedImages)
            } catch {
                print("Failed to load images.")
            }
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPicture))
    }
    
    
    // MARK: - TableView data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let image = images[indexPath.row]
        
        let path = getDocumentsDirectory().appendingPathComponent(image.image)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.textLabel?.text = image.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let path = getDocumentsDirectory().appendingPathComponent(images[indexPath.row].image)
            vc.image = UIImage(contentsOfFile: path.path)
            vc.name = images[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Rename") { action, view, completionHandler in
            
            
            let ac = UIAlertController(title: "Rename item", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Save", style: .default) { action in
                let text = ac.textFields?[0].text
                self.images[indexPath.row].name = text ?? ""
                self.save()
                self.tableView.reloadData()
            })
            
            self.present(ac, animated: true)
            
            
            
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }

    // MARK: - Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        let newImage = Image(image: imageName, name: "Unknown")
        images.append(newImage)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        save()
        tableView.reloadData()
        
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func addPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedImages = try? jsonEncoder.encode(images) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedImages, forKey: "images")
        } else {
            print("failed to save people.")
        }
    }
    
}

