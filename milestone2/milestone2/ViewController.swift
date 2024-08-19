//
//  ViewController.swift
//  milestone2
//
//  Created by Антон Баскаков on 19.08.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAlert)),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentShareSheet))
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    
    @objc func presentAlert() {
        let ac = UIAlertController(title: "Enter item name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let itemName = ac?.textFields?[0].text else { return }
            if !itemName.isEmpty {
                self?.shoppingList.insert(itemName, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        ac.addAction(action)
        
        present(ac, animated: true)
    }
    
    @objc func presentShareSheet() {
        let list = shoppingList.joined(separator: "\n")
        let ac = UIActivityViewController(activityItems: [list], applicationActivities: [])
        
        present(ac, animated: true)
        
    }
    
    @objc func clearList() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
}

