//
//  ViewController.swift
//  milestone7
//
//  Created by Антон Баскаков on 02.10.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        title = "Notes"
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        toolbarItems = [spacer, compose]
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .systemYellow
        
    }
    
    @objc func addNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.viewControllerDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.index = indexPath.row
            vc.viewControllerDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.notes.remove(at: indexPath.row)
            self.saveNotes()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func loadNotes() {
        let decoder = JSONDecoder()
        
        if let decodedNotes = UserDefaults.standard.object(forKey: "notes") as? Data {
            do {
                notes = try decoder.decode([Note].self, from: decodedNotes)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @objc func saveNotes() {
        let encoder = JSONEncoder()
        
        if let savedNotes = try? encoder.encode(notes) {
            UserDefaults.standard.set(savedNotes, forKey: "notes")
        } else {
            print("failed to save notes")
        }
    }


}

